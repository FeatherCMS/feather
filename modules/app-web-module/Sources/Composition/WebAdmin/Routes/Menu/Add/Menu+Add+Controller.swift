import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Add {
    enum Controller {}
}

extension Menu.Add.Controller {
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
