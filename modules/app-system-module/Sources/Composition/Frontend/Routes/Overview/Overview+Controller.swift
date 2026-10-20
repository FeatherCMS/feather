import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Overview {
    enum Controller {}
}

extension WebAdmin.System.Overview.Controller {

    protocol Interface: Sendable {
        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
