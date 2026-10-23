import FeatherValidation
public import FeatherWebShared
import HTML
public import Hummingbird
public import NewsletterWebShared
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
public import WebModuleWebApp

public struct AppNewsletterCampaignSubscription {
    let controller: any AppNewsletterCampaignSubscriptionController

    public static let defaultRoute = NewsletterSubscriptionRoute.standard

    public init(
        apiBuilder: NewsletterAppAPIBuilder,
        route: NewsletterSubscriptionRoute = AppNewsletterCampaignSubscription
            .defaultRoute,
        turnstileVerifier: (any TurnstileVerifier)? = nil
    ) {
        self.controller = AppNewsletterCampaignSubscriptionDefaultController(
            apiBuilder: apiBuilder,
            route: route,
            turnstileVerifier: turnstileVerifier
        )
    }

    public func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
