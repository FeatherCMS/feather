import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

public struct AppNewsletterCampaignSubscription {
    let controller: any AppNewsletterCampaignSubscriptionController

    public init() {
        self.controller = AppNewsletterCampaignSubscriptionDefaultController()
    }

    public func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
