import FeatherAdmin
import Hummingbird

protocol AdminViewDashboardPresenter: Sendable {

    func renderPage(
        model: AdminViewDashboardModel
    ) async throws -> HTMLResponse
}
