import FeatherAdmin
public import FeatherContracts
import Foundation
import Logging
import Markdown
import WebContracts

public struct DefaultMarkdownRenderer: WebContentRenderer {

    private let events: any EventPublisher
    private let mediaResolver: MediaResolver

    public init(
        events: any EventPublisher,
        mediaResolver: MediaResolver
    ) {
        self.events = events
        self.mediaResolver = mediaResolver
    }

    public func render(
        markdown: String
    ) async -> String {
        await render(
            markdown: markdown,
            context: WebMarkdownRenderingContext()
        )
        .html
    }

    public func render(
        markdown: String,
        context: WebMarkdownRenderingContext
    ) async -> (html: String, usesFormSubmissionNonce: Bool) {
        guard !markdown.isEmpty else {
            return (markdown, false)
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
        source = mediaResolver.resolveMarkdownImages(in: source)
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
                    "error": .string(String(describing: error))
                ]
            )
            return (markdown, false)
        }
        if renderers.isEmpty && source.contains("@") {
            Logger.current.error(
                "Markdown contains custom blocks but no block renderers are registered."
            )
        }
        let output = await renderDocument(
            source: source,
            renderers: renderers,
            context: context
        )
        if output.html.isEmpty
            && !markdown.whitespaceTrimmed.isEmpty
        {
            Logger.current.warning(
                "Markdown rendering produced empty output.",
            )
            return (markdown, false)
        }
        return output
    }

    private func renderDocument(
        source: String,
        renderers: [any WebMarkdownBlockRenderer],
        context: WebMarkdownRenderingContext
    ) async -> (html: String, usesFormSubmissionNonce: Bool) {
        let normalizedSource =
            source
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
        let document = Document(
            parsing: normalizedSource,
            options: [.parseBlockDirectives]
        )
        var output = ""
        var usesFormSubmissionNonce = false
        for child in document.children {
            let rendered = await render(
                child,
                renderers: renderers,
                context: context
            )
            output += rendered.html
            usesFormSubmissionNonce =
                usesFormSubmissionNonce || rendered.usesFormSubmissionNonce
        }
        return (output, usesFormSubmissionNonce)
    }

    private func render(
        _ markup: any Markup,
        renderers: [any WebMarkdownBlockRenderer],
        context: WebMarkdownRenderingContext
    ) async -> (html: String, usesFormSubmissionNonce: Bool) {
        guard let directive = markup as? BlockDirective else {
            return (HTMLFormatter.format(markup), false)
        }

        let arguments = directiveArguments(from: directive.argumentText)
        let rawArguments = directive.argumentText.segments
            .map { String($0.trimmedText) }
            .joined(separator: "\n")
        var children: [WebMarkdownBlockRendererRequest.Child] = []
        var childUsesFormSubmissionNonce = false
        for child in directive.children {
            if let childDirective = child as? BlockDirective {
                let rendered = await render(
                    childDirective,
                    renderers: renderers,
                    context: context
                )
                childUsesFormSubmissionNonce =
                    childUsesFormSubmissionNonce
                    || rendered.usesFormSubmissionNonce
                children.append(
                    .init(
                        name: childDirective.name,
                        arguments: directiveArguments(
                            from: childDirective.argumentText
                        ),
                        html: rendered.html
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
            rawArguments: rawArguments,
            children: children,
            formSubmissionNonce: context.formSubmissionNonce,
            formSubmissionFeedback: context.formSubmissionFeedback
        )
        guard
            let renderer = renderers.first(where: {
                $0.name.caseInsensitiveCompare(directive.name) == .orderedSame
            })
        else {
            if directive.name.caseInsensitiveCompare("Cell") == .orderedSame {
                return (
                    children.map { $0.html }.joined(),
                    childUsesFormSubmissionNonce
                )
            }
            return (HTMLFormatter.format(markup), false)
        }
        guard let html = await renderer.render(request: request) else {
            return (HTMLFormatter.format(markup), false)
        }
        return (
            html,
            childUsesFormSubmissionNonce
                || (renderer.usesFormSubmissionNonce
                    && context.formSubmissionNonce != nil)
        )
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
