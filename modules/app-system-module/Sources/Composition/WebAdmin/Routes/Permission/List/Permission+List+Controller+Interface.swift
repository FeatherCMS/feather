import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Permission.List.Controller {
    protocol Interface: Sendable {

        func getSystemPermissions(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
