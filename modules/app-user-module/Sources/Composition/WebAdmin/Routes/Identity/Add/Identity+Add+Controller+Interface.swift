import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Identity.Add.Controller {
    protocol Interface: Sendable {

        func getAddUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
