public import FeatherModuleKit
import WebModuleWebApp
public import NewsletterWebShared

public enum NewsletterMarkdownEventHandlers {
    public static func register(
        in registry: inout EventRegistry,
        submissionRoute: NewsletterSubscriptionRoute = .standard,
        turnstileSiteKey: String? = nil
    ) {
        registry.register(
            event: MarkdownBlockRendererProvider.self,
            context: MarkdownBlockRendererRequest.self
        ) { _, _ in
            NewsletterCampaignMarkdownBlockRenderer(
                submissionRoute: submissionRoute,
                turnstileSiteKey: turnstileSiteKey
            )
        }
    }
}
