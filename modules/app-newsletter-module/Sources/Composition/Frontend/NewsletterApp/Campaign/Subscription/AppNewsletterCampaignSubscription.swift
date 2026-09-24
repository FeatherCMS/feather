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

    public init(apiBuilder: NewsletterAPIBuilder) {
        self.controller = AppNewsletterCampaignSubscriptionDefaultController(
            apiBuilder: apiBuilder
        )
    }

    public func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
