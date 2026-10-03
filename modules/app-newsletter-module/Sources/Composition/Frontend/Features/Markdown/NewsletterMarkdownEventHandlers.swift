public import FeatherContracts
public import WebFrontend

public enum NewsletterMarkdownEventHandlers {
    public static func register(
        in registry: inout EventRegistry,
        submissionRoute: NewsletterSubscriptionRoute = AppNewsletterCampaignSubscription.defaultRoute,
        formChallengeProvider: (any WebFormChallengeProvider)? = nil
    ) {
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            NewsletterCampaignMarkdownBlockRenderer(
                submissionRoute: submissionRoute,
                formChallengeProvider: formChallengeProvider
            )
        }
    }
}
