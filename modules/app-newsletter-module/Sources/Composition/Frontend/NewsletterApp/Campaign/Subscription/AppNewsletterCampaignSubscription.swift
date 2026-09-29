public import FeatherAdmin
import FeatherValidation
import HTML
public import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct AppNewsletterCampaignSubscription {
    let controller: any AppNewsletterCampaignSubscriptionController

    public static let defaultRoute = NewsletterSubscriptionRoute(
        prefix: RouterPath("api/v1/newsletter/campaigns"),
        parameterName: "campaignKey",
        suffix: RouterPath("subscribe")
    )

    public init(
        apiBuilder: NewsletterAPIBuilder,
        route: NewsletterSubscriptionRoute = AppNewsletterCampaignSubscription.defaultRoute
    ) {
        self.controller = AppNewsletterCampaignSubscriptionDefaultController(
            apiBuilder: apiBuilder,
            route: route
        )
    }

    public func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
