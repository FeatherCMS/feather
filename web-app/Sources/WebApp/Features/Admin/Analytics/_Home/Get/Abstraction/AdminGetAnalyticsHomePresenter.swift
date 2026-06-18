import Hummingbird

protocol AdminGetAnalyticsHomePresenter: Sendable {

    func renderHome(
        model: AdminGetAnalyticsHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
