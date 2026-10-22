import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Role.List.Controller {
    protocol Interface: Sendable {

        func getUserRoles(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
