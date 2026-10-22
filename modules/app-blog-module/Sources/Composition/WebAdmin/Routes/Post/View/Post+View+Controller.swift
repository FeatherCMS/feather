import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post {
    enum View {}
}

extension Post.View {
    enum Controller {}
}

extension Post.View.Controller {
    protocol Interface: Sendable {
        func getBlogPost(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
