import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Role.Remove {
    enum Controller {}
}

extension Role.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveUserRole(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response

        func postRemoveUserRoles(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> Response
    }
}
