import FeatherAdmin
import Hummingbird

protocol AdminViewAnalyticsInsightsPresenter: Sendable {
    func render(
        page: AdminAnalyticsInsightsPage,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderError(
        source: AdminAnalyticsInsightsPage.Source,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderDenied(
        source: AdminAnalyticsInsightsPage.Source,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
