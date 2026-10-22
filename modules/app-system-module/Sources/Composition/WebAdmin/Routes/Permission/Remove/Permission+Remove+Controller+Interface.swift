import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Permission.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveSystemPermissions(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
