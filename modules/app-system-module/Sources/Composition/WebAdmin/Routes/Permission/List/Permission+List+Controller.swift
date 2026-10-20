import FeatherAdmin
import Hummingbird
import SystemModule

extension Permission.List {
    enum Controller {}
}

extension Permission.List.Controller {
    protocol Interface: Sendable {

        func getSystemPermissions(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
