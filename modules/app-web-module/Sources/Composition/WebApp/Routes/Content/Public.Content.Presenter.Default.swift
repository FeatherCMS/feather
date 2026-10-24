import FeatherModuleKit
import FeatherWebApp
import Foundation
import Hummingbird
import WebModule

extension Public.Content.Presenter {
    struct Default: Interface {
        let themeRenderer: any PublicThemeRenderer
        let contentRenderer: any ContentRenderer

        func render(
            content: Public.Content.Model,
            formSubmissionNonce: String,
            formSubmissionFeedback: FormSubmissionFeedback?
        ) async -> Output {
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
            return Output(
                response: themeRenderer.render(
                    templateIdentifier: content.metadata.template,
                    context: page.values
                ),
                usesFormSubmissionNonce: page.usesFormSubmissionNonce
            )
        }

        func renderRSS(model: Public.RSS.Model) -> String {
            Public.RSS.XML.render(
                title: model.title,
                description: model.description,
                siteURL: model.siteURL,
                items: model.items
            )
        }

        func renderSitemap(model: Public.Sitemap.Model) -> String {
            Public.Sitemap.XML.render(
                slugs: model.slugs,
                baseURL: model.baseURL
            )
        }

        private func buildContext(
            from results: [PublicContentResult]
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
            formSubmissionFeedback: FormSubmissionFeedback?,
            usesFormSubmissionNonce: Bool
        ) async -> Context {
            let pageKey = "page"
            guard let page = context[pageKey] as? [String: any Sendable] else {
                return Context(
                    values: context,
                    usesFormSubmissionNonce: usesFormSubmissionNonce
                )
            }
            var result = context
            let rendered = await renderPageContentsToContext(
                context: page,
                formSubmissionNonce: formSubmissionNonce,
                formSubmissionFeedback: formSubmissionFeedback
            )
            result[pageKey] = rendered.values
            return Context(
                values: result,
                usesFormSubmissionNonce:
                    usesFormSubmissionNonce || rendered.usesFormSubmissionNonce
            )
        }

        private func renderPageContentsToContext(
            context: [String: any Sendable],
            formSubmissionNonce: String,
            formSubmissionFeedback: FormSubmissionFeedback?
        ) async -> Context {
            var result = context
            let contents = context["contents"]
            let markdown =
                (contents as? [String: any Sendable])?["html"] as? String
                ?? (contents as? [String: String])?["html"]
                ?? (context["content"] as? String)
            guard let markdown else {
                return Context(values: result, usesFormSubmissionNonce: false)
            }
            var renderedContents: [String: any Sendable] =
                (contents as? [String: any Sendable])
                ?? ["html": markdown]
            let rendered = await contentRenderer.render(
                markdown: markdown,
                context: MarkdownRenderingContext(
                    formSubmissionNonce: formSubmissionNonce,
                    formSubmissionFeedback: formSubmissionFeedback
                )
            )
            renderedContents["html"] = rendered.html
            result["contents"] = renderedContents
            return Context(
                values: result,
                usesFormSubmissionNonce: rendered.usesFormSubmissionNonce
            )
        }
    }
}
