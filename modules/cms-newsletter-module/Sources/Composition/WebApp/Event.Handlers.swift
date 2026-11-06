public import FeatherModuleKit
public import NewsletterModule
import WebModuleWebApp

extension Event {
    public enum Handlers {
        public static func registerMarkdown(
            in registry: inout EventRegistry,
            submissionRoute: Campaign.Subscription.Route = .standard,
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
