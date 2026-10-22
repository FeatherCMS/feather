import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Author {
    enum Edit {}
}

extension Author.Edit {
    enum Controller {}
}

extension Author.Edit.Controller {
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
