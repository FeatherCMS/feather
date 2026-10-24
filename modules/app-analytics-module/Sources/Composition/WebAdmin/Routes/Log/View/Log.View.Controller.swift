import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Log.View {
    enum Controller {}
}

extension Log.View.Controller {
    protocol Interface: Sendable {
        func getAnalyticsLog(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
