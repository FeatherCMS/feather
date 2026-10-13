import FeatherAdmin

protocol AdminViewAccountOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminViewAccountOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
