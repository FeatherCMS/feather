import FeatherAdmin
import HTML
import Hummingbird
import SystemModule

extension Variable.Add {
    enum Controller {}
}

extension Variable.Add.Controller {
    protocol Interface: Sendable {

        func getAddSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
