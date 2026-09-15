import FeatherAdmin
import Hummingbird

protocol AdminViewAnalyticsInsightsController: Sendable {
    func getInsights(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAnalyticsInsightsController {
}
