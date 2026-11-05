import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Session.List {
    enum Controller {}
}

extension Session.List.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
