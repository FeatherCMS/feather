import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Variable.List {
    enum Controller {}
}

extension WebAdmin.System.Variable.List.Controller {
    protocol Interface: Sendable {

        func getSystemVariables(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
