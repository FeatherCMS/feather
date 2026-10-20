import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.Remove {
    enum Controller {}
}

extension Permission.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveSystemPermissions(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
