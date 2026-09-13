import FeatherAdmin
import Hummingbird

protocol AdminViewUserOverviewPresenter: Sendable {
    func renderPage(model: AdminViewUserOverviewModel) async throws
        -> HTMLResponse
}
