import Hummingbird

protocol AdminListAnalyticsLogPresenter: Sendable {

    func renderListPage(
        model: AdminListAnalyticsLogModel,
        permissions: Set<String>,
        search: String?,
        source: String?,
        method: String?,
        responseCode: String?,
        error: String?
    ) -> HTMLResponse
}
