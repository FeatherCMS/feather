import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Edit {
    enum Controller {}
}

extension WebModule.Menu.Edit.Controller {
    protocol Interface: Sendable {

        func getEditMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
