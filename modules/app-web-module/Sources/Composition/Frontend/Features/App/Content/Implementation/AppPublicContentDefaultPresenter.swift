import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird
import WebContracts

struct AppPublicContentDefaultPresenter: AppPublicContentPresenter {
    let themeRenderer: any PublicThemeRenderer
    let contentRenderer: any WebContentRenderer

    func render(
        content: AppPublicContentModel,
        formSubmissionNonce: String,
        formSubmissionFeedback: WebFormSubmissionFeedback?
    ) async -> (response: HTMLResponse, usesFormSubmissionNonce: Bool) {
        let results = content.results.compactMap { $0 }
        let usesFormSubmissionNonce = results.contains {
            $0.usesFormSubmissionNonce
        }
        var context = buildContext(from: results)
        if usesFormSubmissionNonce {
            context["formSubmissionNonce"] = formSubmissionNonce
        }
        let page = await buildPageContext(
            context: context,
            formSubmissionNonce: formSubmissionNonce,
            formSubmissionFeedback: formSubmissionFeedback,
            usesFormSubmissionNonce: usesFormSubmissionNonce
        )
        return (
            themeRenderer.render(
                templateIdentifier: content.metadata.template,
                context: page.context
            ),
            page.usesFormSubmissionNonce
        )
    }

    func renderRSS(model: AppPublicRSSModel) -> String {
        PublicRSSXML.render(
            title: model.title,
            description: model.description,
            siteURL: model.siteURL,
            items: model.items
        )
    }

    func renderSitemap(model: AppPublicSitemapModel) -> String {
        PublicSitemapXML.render(
            slugs: model.slugs,
            baseURL: model.baseURL
        )
    }

    private func buildContext(
        from results: [WebPublicContentResult]
    ) -> [String: any Sendable] {
        var context: [String: any Sendable] = [:]
        for result in results {
            for (key, value) in result.payload {
                context[key] = value
            }
        }
        return context
    }

    private func buildPageContext(
        context: [String: any Sendable],
        formSubmissionNonce: String,
        formSubmissionFeedback: WebFormSubmissionFeedback?,
        usesFormSubmissionNonce: Bool
    ) async -> (
        context: [String: any Sendable],
        usesFormSubmissionNonce: Bool
    ) {
        let pageKey = "page"
        guard let page = context[pageKey] as? [String: any Sendable] else {
            return (context, usesFormSubmissionNonce)
        }
        var result = context
        let rendered = await renderPageContentsToContext(
            context: page,
            formSubmissionNonce: formSubmissionNonce,
            formSubmissionFeedback: formSubmissionFeedback
        )
        result[pageKey] = rendered.context
        return (
            result,
            usesFormSubmissionNonce || rendered.usesFormSubmissionNonce
        )
    }

    private func renderPageContentsToContext(
        context: [String: any Sendable],
        formSubmissionNonce: String,
        formSubmissionFeedback: WebFormSubmissionFeedback?
    ) async -> (
        context: [String: any Sendable],
        usesFormSubmissionNonce: Bool
    ) {
        var result = context
        let contents = context["contents"]
        let markdown =
            (contents as? [String: any Sendable])?["html"] as? String
            ?? (contents as? [String: String])?["html"]
            ?? (context["content"] as? String)
        guard let markdown else { return (result, false) }
        var renderedContents: [String: any Sendable] =
            (contents as? [String: any Sendable])
            ?? ["html": markdown]
        let rendered = await contentRenderer.render(
            markdown: markdown,
            context: WebMarkdownRenderingContext(
                formSubmissionNonce: formSubmissionNonce,
                formSubmissionFeedback: formSubmissionFeedback
            )
        )
        renderedContents["html"] = rendered.html
        result["contents"] = renderedContents
        return (result, rendered.usesFormSubmissionNonce)
    }
}
