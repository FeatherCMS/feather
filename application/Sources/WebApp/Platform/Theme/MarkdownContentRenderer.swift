import FeatherContracts
import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
import FeatherApplication
import Foundation
import Logging
import Markdown
import WebApplication
import WebContracts

struct MarkdownContentRenderer: WebContentRenderer {

    private let events: any EventPublisher
    private let mediaBaseURL: String

    init(
        events: any EventPublisher,
        mediaBaseURL: String
    ) {
        self.events = events
        self.mediaBaseURL = mediaBaseURL
    }

    func render(
        markdown: String,
        requestPath: String
    ) async -> String {
        guard !markdown.isEmpty else {
            return markdown
        }
        var source = WebImageURLResolver.resolveMarkdownImageURLs(
            in: markdown,
            mediaBaseURL: mediaBaseURL
        )
        var replacements: [String: String] = [:]
        let renderers =
            (try? await events.trigger(
                event: WebMarkdownBlockRendererProvider(
                    request: .init(requestPath: requestPath)
                ),
                using: WebMarkdownBlockRendererRequest(
                    requestPath: requestPath
                )
            )
            .compactMap { $0 }) ?? []
        for renderer in renderers {
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
            output =
                output
                .replacingOccurrences(of: "<p>\(token)</p>", with: html)
                .replacingOccurrences(of: token, with: html)
        }
        if output.isEmpty
            && !markdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            Logger.current.warning(
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
        let prefix = "@\(renderer.name)(id:"
        var lines: [String] = []
        var index = 0
        for line in source.split(
            separator: "\n",
            omittingEmptySubsequences: false
        ) {
            let value = String(line)
            let trimmed = value.trimmingCharacters(in: .whitespaces)
            guard trimmed.hasPrefix(prefix),
                let closingParenthesis = trimmed.firstIndex(of: ")")
            else {
                lines.append(value)
                continue
            }
            let suffix = trimmed[trimmed.index(after: closingParenthesis)...]
                .trimmingCharacters(in: .whitespaces)
            guard suffix.isEmpty || suffix == "{}" else {
                lines.append(value)
                continue
            }
            let identifierStart = trimmed.index(
                trimmed.startIndex,
                offsetBy: prefix.count
            )
            let identifier = String(
                trimmed[identifierStart..<closingParenthesis]
            )
            .trimmingCharacters(in: .whitespaces)
            guard
                let html = await renderer.render(
                    identifier: identifier,
                    requestPath: requestPath
                )
            else {
                lines.append(value)
                continue
            }
            let token = "FEATHERMARKDOWNBLOCK\(renderer.name)\(index)TOKEN"
            index += 1
            replacements[token] = html
            lines.append(token)
        }
        return lines.joined(separator: "\n")
    }

    private func replaceGridBlocks(
        in source: String,
        requestPath: String
    ) async -> String {
        var result = source
        var searchLocation = result.startIndex

        while let gridRange = result.range(
            of: "@Grid(",
            range: searchLocation..<result.endIndex
        ),
            let declarationEnd = result[gridRange.upperBound...]
                .firstIndex(of: ")"),
            let openingBrace = result[declarationEnd...]
                .firstIndex(of: "{"),
            let closingBrace = matchingBrace(
                in: result,
                openingAt: openingBrace
            )
        {

            let bodyStart = result.index(after: openingBrace)
            let body = String(result[bodyStart..<closingBrace])
            let cells = extractGridCells(from: body)
            guard !cells.isEmpty else {
                searchLocation = result.index(after: closingBrace)
                continue
            }

            let settings = gridSettings(
                from: String(result[gridRange.lowerBound...declarationEnd])
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
            let gridClass =
                "grid-"
                + String(settings.desktop)
                + String(settings.tablet)
                + String(settings.mobile)
            let replacement =
                "<div class=\"grid " + gridClass + "\">"
                + renderedCells.joined() + "</div>"
            let fullRange = gridRange.lowerBound...closingBrace
            result.replaceSubrange(fullRange, with: replacement)
            searchLocation = result.index(
                result.startIndex,
                offsetBy: result.distance(
                    from: result.startIndex,
                    to: gridRange.lowerBound
                ) + replacement.count
            )
        }

        return result
    }

    private func extractGridCells(
        from body: String
    ) -> [String] {
        var cells: [String] = []
        var searchLocation = body.startIndex
        while let cellRange = body.range(
            of: "@Cell",
            range: searchLocation..<body.endIndex
        ),
            let openingBrace = body[cellRange.upperBound...]
                .firstIndex(of: "{"),
            let closingBrace = matchingBrace(
                in: body,
                openingAt: openingBrace
            )
        {
            let contentStart = body.index(after: openingBrace)
            cells.append(String(body[contentStart..<closingBrace]))
            searchLocation = body.index(after: closingBrace)
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
            for token in declaration.split(whereSeparator: {
                $0 == " " || $0 == "(" || $0 == ")" || $0 == ","
            }) {
                let parts = token.split(separator: ":", maxSplits: 1)
                guard parts.count == 2, parts[0] == key,
                    let value = Int(parts[1])
                else { continue }
                return max(1, min(4, value))
            }
            return fallback
        }
        return (
            value(for: "desktop", fallback: 3),
            value(for: "tablet", fallback: 2),
            value(for: "mobile", fallback: 1)
        )
    }
}
