public import FeatherContracts
import WebFrontend

public enum NewsletterMarkdownEventHandlers {
    public static func register(
        in registry: inout EventRegistry,
        submissionRoute: NewsletterSubscriptionRoute =
            AppNewsletterCampaignSubscription.defaultRoute,
        turnstileSiteKey: String? = nil
    ) {
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            NewsletterCampaignMarkdownBlockRenderer(
                submissionRoute: submissionRoute,
                turnstileSiteKey: turnstileSiteKey
            )
        }
    }
}
