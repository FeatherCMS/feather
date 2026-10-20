import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.Edit {
    enum Controller {}
}

extension Permission.Edit.Controller {
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
