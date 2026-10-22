import FeatherWebAdmin
import WebDomain
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

extension WebDomain.Menu.Edit {
    enum Controller {}
}

extension WebDomain.Menu.Edit.Controller {
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
