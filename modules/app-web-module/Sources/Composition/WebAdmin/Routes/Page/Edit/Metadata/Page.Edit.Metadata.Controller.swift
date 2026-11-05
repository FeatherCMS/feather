import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebModule

extension Page.Edit.Metadata {
    enum Controller {}
}

extension Page.Edit.Metadata.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
