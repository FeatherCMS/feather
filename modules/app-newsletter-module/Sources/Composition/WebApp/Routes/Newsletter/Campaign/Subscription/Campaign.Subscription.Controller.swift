import FeatherWebShared
import Hummingbird
import NewsletterModule
import WebModuleWebApp

extension Campaign.Subscription {
    enum Controller {}
}

extension Campaign.Subscription.Controller {
    protocol Interface: Sendable {
        var route: Campaign.Subscription.Route { get }

        func subscribe(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}
