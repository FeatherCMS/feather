import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.View {
    enum Controller {}
}

extension Page.View.Controller {
    protocol Interface: Sendable {

        func getPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
