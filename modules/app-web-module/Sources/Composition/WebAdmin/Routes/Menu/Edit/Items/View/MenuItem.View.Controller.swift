import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.View {
    enum Controller {}
}

extension MenuItem.View.Controller {
    protocol Interface: Sendable {
        func getMenuItem(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
