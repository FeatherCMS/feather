public import FeatherModuleKit
import NewsletterModule
public import NewsletterWebShared
import WebModuleWebApp

extension Event {
    public enum Handlers {
        public static func registerMarkdown(
            in registry: inout EventRegistry,
            submissionRoute: NewsletterSubscriptionRoute = .standard,
            turnstileSiteKey: String? = nil
        ) {
            registry.register(
                event: MarkdownBlockRendererProvider.self,
                context: MarkdownBlockRendererRequest.self
            ) { _, _ in
                Campaign.Markdown.BlockRenderer(
                    submissionRoute: submissionRoute,
                    turnstileSiteKey: turnstileSiteKey
                )
            }
        }
    }
}
