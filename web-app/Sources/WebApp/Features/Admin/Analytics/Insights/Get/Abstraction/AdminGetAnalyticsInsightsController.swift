import Hummingbird

protocol AdminGetAnalyticsInsightsController: Sendable {
    func getInsights(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAnalyticsInsightsController {
}
