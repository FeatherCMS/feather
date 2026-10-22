import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.View {
    enum Controller {}
}

extension Menu.View.Controller {
    protocol Interface: Sendable {

        func getMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
