import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post.Status.Controller {
    protocol Interface: Sendable {
        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
