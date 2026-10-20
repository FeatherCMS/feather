import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.View {
    enum Controller {}
}

extension WebAdmin.System.Permission.View.Controller {
    protocol Interface: Sendable {

        func getSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
