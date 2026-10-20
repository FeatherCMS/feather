import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Dashboard {
    enum Controller {}
}

extension WebAdmin.System.Dashboard.Controller {
    protocol Interface: Sendable {

        func getHome(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
