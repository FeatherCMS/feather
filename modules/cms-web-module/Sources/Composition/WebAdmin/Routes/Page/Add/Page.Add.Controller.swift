import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Add {
    enum Controller {}
}

extension Page.Add.Controller {
    protocol Interface: Sendable {

        func getAddPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
