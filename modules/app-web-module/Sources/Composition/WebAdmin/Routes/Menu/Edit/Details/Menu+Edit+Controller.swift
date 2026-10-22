import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Edit {
    enum Controller {}
}

extension Menu.Edit.Controller {
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
