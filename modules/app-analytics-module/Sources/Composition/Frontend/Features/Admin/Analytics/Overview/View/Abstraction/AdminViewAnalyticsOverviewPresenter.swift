import FeatherAdmin
import Hummingbird

protocol AdminViewAnalyticsOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminViewAnalyticsOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
