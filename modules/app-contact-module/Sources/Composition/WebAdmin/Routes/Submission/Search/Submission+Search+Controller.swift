import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Search {
    enum Controller {}
}

extension Submission.Search.Controller {
    protocol Interface: Sendable {
        func list(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func listForForm(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
