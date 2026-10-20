import FeatherAdmin
import Hummingbird
import SystemModule

extension Permission.View {
    enum Controller {}
}

extension Permission.View.Controller {
    protocol Interface: Sendable {

        func getSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
