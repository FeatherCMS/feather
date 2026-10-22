import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post {
    enum Add {}
}

extension Post.Add {
    enum Controller {}
}

extension Post.Add.Controller {
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
