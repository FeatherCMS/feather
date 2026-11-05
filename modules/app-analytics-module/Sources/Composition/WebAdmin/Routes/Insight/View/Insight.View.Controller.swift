import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Insight.View {
    enum Controller {}
}

extension Insight.View.Controller {
    protocol Interface: Sendable {
        func getInsights(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
