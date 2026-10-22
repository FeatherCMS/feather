import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird





extension Post.List.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
