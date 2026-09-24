import FeatherAdmin

protocol AdminViewDashboardPresenter: Sendable {

    func renderPage(
        model: AdminViewDashboardModel
    ) async throws -> HTMLResponse
}
