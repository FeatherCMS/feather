import FeatherAdmin

protocol AdminViewContactOverviewPresenter: Sendable {
    func renderOverview(
        model: AdminViewContactOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
