import FeatherWebShared
import Hummingbird
import NewsletterModule
import NewsletterWebShared
import WebModuleWebApp

extension Campaign.Subscription {
    enum Controller {}
}

extension Campaign.Subscription.Controller {
    protocol Interface: Sendable {
        var route: NewsletterSubscriptionRoute { get }

        func subscribe(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}
