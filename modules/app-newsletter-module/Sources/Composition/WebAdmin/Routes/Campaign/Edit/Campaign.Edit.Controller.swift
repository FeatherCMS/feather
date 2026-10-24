import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Edit {
    enum Controller {}
}

extension Campaign.Edit.Controller {
    protocol Interface: Sendable {
        func edit(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func update(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
