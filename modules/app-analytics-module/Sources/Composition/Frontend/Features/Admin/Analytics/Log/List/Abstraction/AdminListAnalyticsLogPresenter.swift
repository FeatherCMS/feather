import FeatherAdmin

protocol AdminListAnalyticsLogPresenter: Sendable {

    func renderListPage(
        model: AdminListAnalyticsLogModel,
        permissions: Set<String>,
        search: String?,
        source: String?,
        method: String?,
        responseCode: String?,
        from: String,
        to: String,
        error: String?
    ) async throws -> HTMLResponse
}
