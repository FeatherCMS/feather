import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird
import WebContracts

struct AppPublicContentDefaultPresenter: AppPublicContentPresenter {
    let themeRenderer: any PublicThemeRenderer
    let contentRenderer: any WebContentRenderer

    func render(
        content: AppPublicContentModel
    ) async -> HTMLResponse {
        let context = await buildPageContext(
            context: buildContext(from: content.results)
        )
        return themeRenderer.render(
            templateIdentifier: content.metadata.template,
            context: context
        )
    }

    private func buildContext(
        from results: [WebPublicContentProvider.Output]
    ) -> [String: any Sendable] {
        var context: [String: any Sendable] = [:]
        for result in results.compactMap({ $0 }) {
            for (key, value) in result.payload {
                context[key] = value
            }
        }
        return context
    }

    private func buildPageContext(
        context: [String: any Sendable]
    ) async -> [String: any Sendable] {
        let pageKey = "page"
        guard let page = context[pageKey] as? [String: any Sendable] else {
            return context
        }
        var result = context
        result[pageKey] = await renderPageContentsToContext(
            context: page
        )
        return result
    }

    private func renderPageContentsToContext(
        context: [String: any Sendable]
    ) async -> [String: any Sendable] {
        var result = context
        let contents = context["contents"]
        let markdown =
            (contents as? [String: any Sendable])?["html"] as? String
            ?? (contents as? [String: String])?["html"]
            ?? (context["content"] as? String)
        guard let markdown else { return result }
        var renderedContents: [String: any Sendable] =
            (contents as? [String: any Sendable])
            ?? ["html": markdown]
        renderedContents["html"] = await contentRenderer.render(
            markdown: markdown
        )
        result["contents"] = renderedContents
        return result
    }
}
