import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post.View.Controller {
    protocol Interface: Sendable {
        func getBlogPost(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}

extension Post.View {
    enum Controller {}
}
