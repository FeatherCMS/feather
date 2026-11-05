import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.Edit {
    enum Controller {}
}

extension MenuItem.Edit.Controller {
    protocol Interface: Sendable {
        func getEditMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
