import FeatherAdmin
import Hummingbird

protocol AdminGetUserOverviewPresenter: Sendable {
    func renderPage(model: AdminGetUserOverviewModel) async throws
        -> HTMLResponse
}
