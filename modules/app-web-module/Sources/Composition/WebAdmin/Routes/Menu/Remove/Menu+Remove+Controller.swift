import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Remove {
    enum Controller {}
}

extension WebModule.Menu.Remove.Controller {
    protocol Interface: Sendable {

        func getRemoveMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postRemoveMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
