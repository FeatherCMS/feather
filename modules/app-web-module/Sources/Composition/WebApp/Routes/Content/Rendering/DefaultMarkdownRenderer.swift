public import FeatherModuleKit
import Foundation
import Logging
import Markdown
import WebModule

public struct DefaultMarkdownRenderer: ContentRenderer {

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
            context: MarkdownRenderingContext()
        )
        .html
    }

    public func render(
        markdown: String,
        context: MarkdownRenderingContext
    ) async -> (html: String, usesFormSubmissionNonce: Bool) {
        guard !markdown.isEmpty else {
            return (markdown, false)
        }
        var source = markdown
        let transformers =
            (try? await events.trigger(
                event: MarkdownSourceTransformerProvider(),
                using: MarkdownSourceTransformerRequest()
            )
            .compactMap { $0 }
            .sorted { $0.priority < $1.priority }) ?? []
        for transformer in transformers {
            source = await transformer.transform(source)
        }
        source = mediaResolver.resolveMarkdownImages(in: source)
        let renderers: [any MarkdownBlockRenderer]
        do {
            renderers =
                try await events.trigger(
                    event: MarkdownBlockRendererProvider(),
                    using: MarkdownBlockRendererRequest()
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
        renderers: [any MarkdownBlockRenderer],
        context: MarkdownRenderingContext
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
        renderers: [any MarkdownBlockRenderer],
        context: MarkdownRenderingContext
    ) async -> (
        html: String, usesFormSubmissionNonce: Bool,
        node: MarkdownBlockRendererRequest.Child?
    ) {
        guard let directive = markup as? BlockDirective else {
            return (HTMLFormatter.format(markup), false, nil)
        }

        let arguments = directiveArguments(from: directive.argumentText)
        var children: [MarkdownBlockRendererRequest.Child] = []
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
                if let node = rendered.node { children.append(node) }
                continue
            }
            children.append(
                .init(
                    name: "",
                    arguments: [:],
                    html: HTMLFormatter.format(child),
                    children: []
                )
            )
        }

        let request = MarkdownBlockRendererRequest(
            arguments: arguments,
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
                    childUsesFormSubmissionNonce,
                    .init(
                        name: directive.name,
                        arguments: arguments,
                        html: children.map { $0.html }.joined(),
                        children: children
                    )
                )
            }
            let html = HTMLFormatter.format(markup)
            return (
                html, false,
                .init(
                    name: directive.name,
                    arguments: arguments,
                    html: html,
                    children: children
                )
            )
        }
        guard let html = await renderer.render(request: request) else {
            let html = HTMLFormatter.format(markup)
            return (
                html, false,
                .init(
                    name: directive.name,
                    arguments: arguments,
                    html: html,
                    children: children
                )
            )
        }
        return (
            html,
            childUsesFormSubmissionNonce
                || (renderer.usesFormSubmissionNonce
                    && context.formSubmissionNonce != nil),
            .init(
                name: directive.name,
                arguments: arguments,
                html: html,
                children: children
            )
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
