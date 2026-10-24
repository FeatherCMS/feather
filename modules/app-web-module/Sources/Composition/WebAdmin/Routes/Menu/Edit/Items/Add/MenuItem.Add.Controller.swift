import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.Add {
    enum Controller {}
}

extension MenuItem.Add.Controller {
    protocol Interface: Sendable {
        func getAddMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
