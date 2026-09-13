import FeatherAdmin
import Hummingbird

protocol AdminGetAccountOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminGetAccountOverviewModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
