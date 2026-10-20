import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.Remove {
    enum Controller {}
}

extension WebAdmin.System.Permission.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveSystemPermissions(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
