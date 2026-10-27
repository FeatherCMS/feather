import FeatherWebApp
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Unsubscribe {
    enum Controller {}
}

extension Campaign.Unsubscribe.Controller {
    protocol Interface: Sendable {
        var route: Campaign.Unsubscribe.Route { get }

        func getConfirmation(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse

        func postOneClick(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response

        func postConfirmation(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> WebAppHTMLResponse
    }
}
