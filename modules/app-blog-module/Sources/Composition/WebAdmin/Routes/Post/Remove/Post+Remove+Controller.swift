import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post.Remove.Controller {
    protocol Interface: Sendable {
        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
