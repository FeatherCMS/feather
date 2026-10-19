import SystemModule
import FeatherAdmin

protocol AdminViewDesignSystemPresenter: Sendable {

    func renderPage(
        model: AdminViewDesignSystemModel
    ) async throws -> HTMLResponse
}
