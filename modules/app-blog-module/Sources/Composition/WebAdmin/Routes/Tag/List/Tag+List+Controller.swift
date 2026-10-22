import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Tag.List.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postStatus(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
