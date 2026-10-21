import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Role.Edit {
    enum Controller {}
}

extension Role.Edit.Controller {
    protocol Interface: Sendable {

        func getEditUserRole(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditUserRole(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
