import FeatherAdmin
import Hummingbird

protocol AdminGetSystemOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminGetSystemOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
