import Foundation
import Logging
import Markdown

struct MarkdownContentRenderer: ContentRenderer {
    private let logger: Logger
    private let blockRenderers: [any MarkdownBlockRenderer]

    init(
        api: ApplicationAPI,
        logger: Logger = .init(label: "WebApp.Theme.MarkdownContentRenderer")
    ) {
        self.logger = logger
        self.blockRenderers = [ContactFormBlockRenderer(api: api), NewsletterCampaignBlockRenderer(api: api)]
    }

    func render(
        markdown: String,
        requestPath: String
    ) async -> String {
        guard !markdown.isEmpty else {
            return markdown
        }
        var source = markdown
        var replacements: [String: String] = [:]
        for renderer in blockRenderers {
            source = await replaceBlocks(
                in: source,
                renderer: renderer,
                requestPath: requestPath,
                replacements: &replacements
            )
        }
        var output = HTMLFormatter.format(
            Document(parsing: source)
        )
        for (token, html) in replacements {
            output = output
                .replacingOccurrences(of: "<p>\(token)</p>", with: html)
                .replacingOccurrences(of: token, with: html)
        }
        if output.isEmpty && !markdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            logger.warning(
                "Markdown rendering produced empty output.",
                metadata: [
                    "path": .string(requestPath)
                ]
            )
            return markdown
        }
        return output
    }

    private func replaceBlocks(
        in source: String,
        renderer: any MarkdownBlockRenderer,
        requestPath: String,
        replacements: inout [String: String]
    ) async -> String {
        let pattern = "(?m)^@\(renderer.name)\\(id:\\s*([^\\)]+)\\)\\s*(?:\\{\\s*\\})?\\s*$"
        guard let expression = try? NSRegularExpression(pattern: pattern) else { return source }
        let range = NSRange(source.startIndex..<source.endIndex, in: source)
        let matches = expression.matches(in: source, range: range)
        var result = source
        for (index, match) in matches.enumerated().reversed() {
            guard let identifierRange = Range(match.range(at: 1), in: source), let fullRange = Range(match.range, in: source) else { continue }
            let identifier = String(source[identifierRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            guard let html = await renderer.render(identifier: identifier, requestPath: requestPath) else { continue }
            let token = "FEATHERMARKDOWNBLOCK\(renderer.name)\(index)TOKEN"
            replacements[token] = html
            let replacement = "\n\n\(token)\n\n"
            result.replaceSubrange(fullRange, with: replacement)
        }
        return result
    }
}
