import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post.Edit.Controller {
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

extension Post.Edit {
    enum Controller {}
}
