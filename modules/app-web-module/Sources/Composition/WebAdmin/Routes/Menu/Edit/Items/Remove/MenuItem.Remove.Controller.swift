import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.Remove {
    enum Controller {}
}

extension MenuItem.Remove.Controller {
    protocol Interface: Sendable {
        func getRemoveMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postRemoveMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
