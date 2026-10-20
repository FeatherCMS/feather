import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.Edit {
    enum Controller {}
}

extension WebAdmin.System.Permission.Edit.Controller {
    protocol Interface: Sendable {

        func getEditSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
