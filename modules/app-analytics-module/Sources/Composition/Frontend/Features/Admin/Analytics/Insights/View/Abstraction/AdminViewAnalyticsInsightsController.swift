import FeatherAdmin
import Hummingbird

protocol AdminViewAnalyticsInsightsController: Sendable {
    func getInsights(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAnalyticsInsightsController {
}
