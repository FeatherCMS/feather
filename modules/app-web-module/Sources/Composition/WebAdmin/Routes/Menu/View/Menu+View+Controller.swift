import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.View {
    enum Controller {}
}

extension WebModule.Menu.View.Controller {
    protocol Interface: Sendable {

        func getMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
