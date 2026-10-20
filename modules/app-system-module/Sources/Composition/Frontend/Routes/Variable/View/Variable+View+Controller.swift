import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Variable.View {
    enum Controller {}
}

extension WebAdmin.System.Variable.View.Controller {
    protocol Interface: Sendable {

        func getSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
