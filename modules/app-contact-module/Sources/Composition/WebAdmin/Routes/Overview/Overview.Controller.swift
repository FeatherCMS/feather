import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Contact.Overview {
    enum Controller {}
}

extension Contact.Overview.Controller {
    protocol Interface: Sendable {
        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
