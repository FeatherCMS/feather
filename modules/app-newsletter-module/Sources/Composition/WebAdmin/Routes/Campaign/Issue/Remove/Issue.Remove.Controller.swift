import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Remove {
    enum Controller {}
}

extension Issue.Remove.Controller {
    protocol Interface: Sendable {
        func confirm(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func remove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response

        func removeSelected(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
