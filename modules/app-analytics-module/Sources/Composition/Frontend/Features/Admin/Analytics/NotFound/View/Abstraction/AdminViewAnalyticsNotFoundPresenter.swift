import FeatherAdmin

protocol AdminViewAnalyticsNotFoundPresenter: Sendable {

    func render(
        model: AdminViewAnalyticsNotFoundModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderDenied(
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderError(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
