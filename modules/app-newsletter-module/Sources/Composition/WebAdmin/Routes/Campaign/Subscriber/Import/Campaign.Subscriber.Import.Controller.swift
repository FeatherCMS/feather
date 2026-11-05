import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Import {
    enum Controller {}
}

extension Campaign.Subscriber.Import.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
