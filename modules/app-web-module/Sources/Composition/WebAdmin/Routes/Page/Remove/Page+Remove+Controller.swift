import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page {
    enum Remove {}
}

extension Page.Remove {
    enum Controller {}
}

extension Page.Remove.Controller {
    protocol Interface: Sendable {

        func getRemovePage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postRemovePage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
