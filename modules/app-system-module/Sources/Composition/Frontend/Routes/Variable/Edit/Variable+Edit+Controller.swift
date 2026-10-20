import FeatherAdmin
import HTML
import Hummingbird
import SystemModule

extension WebAdmin.System.Variable.Edit {
    enum Controller {}
}

extension WebAdmin.System.Variable.Edit.Controller {
    protocol Interface: Sendable {

        func getEditSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
