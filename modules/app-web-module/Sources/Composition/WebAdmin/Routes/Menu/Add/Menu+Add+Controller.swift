import FeatherWebAdmin
import WebDomain
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

extension WebDomain.Menu.Add {
    enum Controller {}
}

extension WebDomain.Menu.Add.Controller {
    protocol Interface: Sendable {

        func getAddMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
