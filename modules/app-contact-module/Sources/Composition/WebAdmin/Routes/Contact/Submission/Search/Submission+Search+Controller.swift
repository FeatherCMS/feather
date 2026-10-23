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
    }
}

extension Submission.Search.Controller.Interface {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.submissions, use: list)
    }
}
