import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.Add {
    enum Controller {}
}

extension WebAdmin.System.Permission.Add.Controller {
    protocol Interface: Sendable {

        func getAddSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
