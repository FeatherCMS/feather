import FeatherAdmin
import Hummingbird

protocol AdminGetSystemOverviewPresenter: Sendable {

    func renderHome(
        model: AdminGetSystemOverviewModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
