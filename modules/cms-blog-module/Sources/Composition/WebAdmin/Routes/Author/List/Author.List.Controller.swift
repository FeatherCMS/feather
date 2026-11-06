import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Author.List.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postStatusPath(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}

extension Author.List {
    enum Controller {}
}
