import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Settings.Edit {
    enum Controller {}
}

extension Settings.Edit.Controller {
    protocol Interface: Sendable {
        func getEditSettings(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditSettings(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
