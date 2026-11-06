import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Edit {
    enum Controller {}
}

extension Page.Edit.Controller {
    protocol Interface: Sendable {

        func getEditPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
