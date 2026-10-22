import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird





extension AuthorLink.List.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
