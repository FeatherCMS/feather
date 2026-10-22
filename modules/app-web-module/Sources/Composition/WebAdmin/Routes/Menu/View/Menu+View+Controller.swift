import FeatherWebAdmin
import WebDomain
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

extension WebDomain.Menu.View {
    enum Controller {}
}

extension WebDomain.Menu.View.Controller {
    protocol Interface: Sendable {

        func getMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
