import FeatherAdmin
import Hummingbird

protocol AdminGetAnalyticsInsightsController: Sendable {
    func getInsights(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAnalyticsInsightsController {
}
