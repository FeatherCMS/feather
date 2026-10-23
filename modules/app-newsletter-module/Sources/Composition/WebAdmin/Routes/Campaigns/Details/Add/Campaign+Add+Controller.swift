import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Add {
    enum Controller {}
}

extension Campaign.Add.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func add(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
