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
        var source = resolveMediaURLs(in: markdown)
        var replacements: [String: String] = [:]
        for renderer in blockRenderers {
            source = await replaceBlocks(
                in: source,
                renderer: renderer,
                requestPath: requestPath,
                replacements: &replacements
            )
        }
        source = await replaceGridBlocks(
            in: source,
            requestPath: requestPath
        )
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

    private func resolveMediaURLs(
        in source: String
    ) -> String {
        let mediaBaseURL = AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString
        guard let expression = try? NSRegularExpression(
            pattern: #"(?<![A-Za-z0-9:/._-])(/media/assets/[A-Za-z0-9._~/%+-]+)"#
        )
        else {
            return source
        }
        let range = NSRange(source.startIndex..<source.endIndex, in: source)
        return expression.stringByReplacingMatches(
            in: source,
            range: range,
            withTemplate: NSRegularExpression.escapedTemplate(for: mediaBaseURL) + "$1"
        )
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

    private func replaceGridBlocks(
        in source: String,
        requestPath: String
    ) async -> String {
        let pattern = #"@Grid\(([^)]*)\)\s*\{"#
        guard let expression = try? NSRegularExpression(pattern: pattern) else {
            return source
        }

        var result = source
        var searchLocation = result.startIndex

        while searchLocation < result.endIndex {
            let searchRange = NSRange(searchLocation..<result.endIndex, in: result)
            guard let match = expression.firstMatch(in: result, range: searchRange),
                  let matchRange = Range(match.range, in: result),
                  let openingBrace = result[matchRange].lastIndex(of: "{")
            else {
                break
            }
            guard let closingBrace = matchingBrace(
                in: result,
                openingAt: openingBrace
            )
            else {
                break
            }

            let bodyStart = result.index(after: openingBrace)
            let body = String(result[bodyStart..<closingBrace])
            let cells = extractGridCells(from: body)
            guard !cells.isEmpty else {
                searchLocation = result.index(after: closingBrace)
                continue
            }

            let settings = gridSettings(
                from: String(result[matchRange])
            )
            var renderedCells: [String] = []
            for cell in cells {
                let html = await render(
                    markdown: cell,
                    requestPath: requestPath
                )
                renderedCells.append(
                    "<div>" + html + "</div>"
                )
            }
            let gridClass = "grid-"
                + String(settings.desktop)
                + String(settings.tablet)
                + String(settings.mobile)
            let replacement = "<div class=\"grid " + gridClass + "\">"
                + renderedCells.joined() + "</div>"
            let fullRange = matchRange.lowerBound...closingBrace
            result.replaceSubrange(fullRange, with: replacement)
            searchLocation = result.index(
                result.startIndex,
                offsetBy: result.distance(from: result.startIndex, to: matchRange.lowerBound) + replacement.count
            )
        }

        return result
    }

    private func extractGridCells(
        from body: String
    ) -> [String] {
        let pattern = #"@Cell\s*\{"#
        guard let expression = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        let range = NSRange(body.startIndex..<body.endIndex, in: body)
        let matches = expression.matches(in: body, range: range)
        var cells: [String] = []
        for match in matches {
            guard let matchRange = Range(match.range, in: body),
                  let openingBrace = body[matchRange].lastIndex(of: "{"),
                  let closingBrace = matchingBrace(in: body, openingAt: openingBrace)
            else {
                continue
            }
            let contentStart = body.index(after: openingBrace)
            cells.append(String(body[contentStart..<closingBrace]))
        }
        return cells
    }

    private func matchingBrace(
        in source: String,
        openingAt: String.Index
    ) -> String.Index? {
        var depth = 0
        var index = openingAt
        while index < source.endIndex {
            if source[index] == "{" {
                depth += 1
            }
            else if source[index] == "}" {
                depth -= 1
                if depth == 0 {
                    return index
                }
            }
            index = source.index(after: index)
        }
        return nil
    }

    private func gridSettings(
        from declaration: String
    ) -> (desktop: Int, tablet: Int, mobile: Int) {
        func value(for key: String, fallback: Int) -> Int {
            let pattern = "\\b\(key)\\s*:\\s*(\\d+)"
            guard let expression = try? NSRegularExpression(pattern: pattern),
                  let match = expression.firstMatch(
                    in: declaration,
                    range: NSRange(declaration.startIndex..<declaration.endIndex, in: declaration)
                  ),
                  let range = Range(match.range(at: 1), in: declaration),
                  let value = Int(declaration[range])
            else {
                return fallback
            }
            return max(1, min(4, value))
        }
        return (
            value(for: "desktop", fallback: 3),
            value(for: "tablet", fallback: 2),
            value(for: "mobile", fallback: 1)
        )
    }
}
