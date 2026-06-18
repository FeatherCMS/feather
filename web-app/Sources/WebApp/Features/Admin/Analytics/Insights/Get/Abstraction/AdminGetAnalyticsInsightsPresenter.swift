import Hummingbird

protocol AdminGetAnalyticsInsightsPresenter: Sendable {
    func render(
        page: AdminAnalyticsInsightsPage,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        source: AdminAnalyticsInsightsPage.Source,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDenied(
        source: AdminAnalyticsInsightsPage.Source,
        permissions: Set<String>
    ) -> HTMLResponse
}
