import FeatherAdmin
import Hummingbird

protocol AdminGetDashboardPresenter: Sendable {

    func renderPage(
        model: AdminGetDashboardModel
    ) -> HTMLResponse
}
