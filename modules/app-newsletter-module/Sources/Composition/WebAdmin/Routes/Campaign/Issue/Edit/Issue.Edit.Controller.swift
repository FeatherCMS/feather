import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Edit {
    enum Controller {}
}

extension Issue.Edit.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func edit(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
