import FeatherAdmin
import FeatherContracts
import Foundation
import Logging
import Markdown
import WebContracts

public struct DefaultMarkdownRenderer: WebContentRenderer {

    private let events: any EventPublisher
    private let mediaBaseURL: String

    public init(
        events: any EventPublisher,
        mediaBaseURL: String
    ) {
        self.events = events
        self.mediaBaseURL = mediaBaseURL
    }

    public func render(
        markdown: String
    ) async -> String {
        guard !markdown.isEmpty else {
            return markdown
        }
        var source = markdown
        let transformers =
            (try? await events.trigger(
                event: WebMarkdownSourceTransformerProvider(),
                using: WebMarkdownSourceTransformerRequest()
            )
            .compactMap { $0 }
            .sorted { $0.priority < $1.priority }) ?? []
        for transformer in transformers {
            source = await transformer.transform(source)
        }
        source = WebImageURLResolver.resolveMarkdownImageURLs(
            in: source,
            mediaBaseURL: mediaBaseURL
        )
        let renderers: [any WebMarkdownBlockRenderer]
        do {
            renderers =
                try await events.trigger(
                    event: WebMarkdownBlockRendererProvider(),
                    using: WebMarkdownBlockRendererRequest()
                )
                .compactMap { $0 }
        }
        catch {
            Logger.current.error(
                "Markdown block renderer providers failed.",
                metadata: [
                    "error": .string(String(describing: error)),
                ]
            )
            return markdown
        }
        if renderers.isEmpty && source.contains("@") {
            Logger.current.error(
                "Markdown contains custom blocks but no block renderers are registered."
            )
        }
        let output = await renderDocument(source: source, renderers: renderers)
        if output.isEmpty
            && !markdown.whitespaceTrimmed.isEmpty
        {
            Logger.current.warning(
                "Markdown rendering produced empty output.",
            )
            return markdown
        }
        return output
    }

    private func renderDocument(
        source: String,
        renderers: [any WebMarkdownBlockRenderer]
    ) async -> String {
        let normalizedSource =
            source
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
        let document = Document(
            parsing: normalizedSource,
            options: [.parseBlockDirectives]
        )
        var output = ""
        for child in document.children {
            output += await render(child, renderers: renderers)
        }
        return output
    }

    private func render(
        _ markup: any Markup,
        renderers: [any WebMarkdownBlockRenderer]
    ) async -> String {
        guard let directive = markup as? BlockDirective else {
            return HTMLFormatter.format(markup)
        }

        let arguments = directiveArguments(from: directive.argumentText)
        var children: [WebMarkdownBlockRendererRequest.Child] = []
        for child in directive.children {
            if let childDirective = child as? BlockDirective {
                children.append(
                    .init(
                        name: childDirective.name,
                        arguments: directiveArguments(
                            from: childDirective.argumentText
                        ),
                        html: await render(
                            childDirective,
                            renderers: renderers
                        )
                    )
                )
                continue
            }
            children.append(
                .init(
                    name: "",
                    arguments: [:],
                    html: HTMLFormatter.format(child)
                )
            )
        }

        let request = WebMarkdownBlockRendererRequest(
            arguments: arguments,
            children: children
        )
        guard
            let renderer = renderers.first(where: {
                $0.name.caseInsensitiveCompare(directive.name) == .orderedSame
            })
        else {
            if directive.name.caseInsensitiveCompare("Cell") == .orderedSame {
                return children.map { $0.html }.joined()
            }
            return HTMLFormatter.format(markup)
        }
        return await renderer.render(request: request)
            ?? HTMLFormatter.format(markup)
    }

    private func directiveArguments(
        from arguments: DirectiveArgumentText
    ) -> [String: String] {
        Dictionary(
            uniqueKeysWithValues:
                arguments
                .parseNameValueArguments()
                .map { ($0.name, $0.value) }
        )
    }
}
