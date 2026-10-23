import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SystemModule

extension Variable.Edit {
    enum Controller {}
}

extension Variable.Edit.Controller {
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
