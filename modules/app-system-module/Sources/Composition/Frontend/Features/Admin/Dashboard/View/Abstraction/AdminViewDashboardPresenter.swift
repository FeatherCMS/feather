import FeatherAdmin
import Hummingbird

protocol AdminViewDashboardPresenter: Sendable {

    func renderPage(
        model: AdminViewDashboardModel
    ) -> HTMLResponse
}
