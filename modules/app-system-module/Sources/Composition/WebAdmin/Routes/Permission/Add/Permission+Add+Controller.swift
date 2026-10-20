import FeatherAdmin
import Hummingbird
import SystemModule

extension Permission.Add {
    enum Controller {}
}

extension Permission.Add.Controller {
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
