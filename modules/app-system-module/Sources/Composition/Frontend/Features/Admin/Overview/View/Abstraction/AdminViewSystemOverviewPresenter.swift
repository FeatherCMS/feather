import FeatherAdmin
import Hummingbird

protocol AdminViewSystemOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminViewSystemOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
