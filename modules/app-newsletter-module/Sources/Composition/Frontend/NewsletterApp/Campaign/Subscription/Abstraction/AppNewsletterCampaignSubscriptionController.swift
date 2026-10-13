import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AppNewsletterCampaignSubscriptionController: Sendable {
    var route: NewsletterSubscriptionRoute { get }

    func subscribe(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AppNewsletterCampaignSubscriptionController {
    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.post(route.routerPath, use: subscribe)
    }
}
