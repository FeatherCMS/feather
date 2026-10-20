import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.List {
    enum Controller {}
}

extension WebAdmin.System.Permission.List.Controller {
    protocol Interface: Sendable {

        func getSystemPermissions(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
