import FeatherAdmin
import Hummingbird

protocol AdminViewDesignSystemPresenter: Sendable {

    func renderPage(
        model: AdminViewDesignSystemModel
    ) async throws -> HTMLResponse
}
