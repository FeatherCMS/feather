import FeatherAdmin

protocol AdminViewAnalyticsLogPresenter: Sendable {

    func renderPage(
        model: AdminViewAnalyticsLogModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
