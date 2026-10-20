import FeatherAdmin
import HTML
import Hummingbird
import SystemModule

extension WebAdmin.System.Variable.Remove {
    enum Controller {}
}

extension WebAdmin.System.Variable.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveSystemVariables(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
