import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Role.Add.Controller {
    protocol Interface: Sendable {

        func getAddUserRole(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddUserRole(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
