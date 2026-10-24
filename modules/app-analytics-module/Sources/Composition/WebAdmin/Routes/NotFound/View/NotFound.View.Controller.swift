import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension NotFound.View {
    enum Controller {}
}

extension NotFound.View.Controller {
    protocol Interface: Sendable {
        func getNotFound(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
