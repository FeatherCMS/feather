import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.List {
    enum Controller {}
}

extension MenuItem.List.Controller {
    protocol Interface: Sendable {
        func getMenuItems(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postMenuItemMove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
