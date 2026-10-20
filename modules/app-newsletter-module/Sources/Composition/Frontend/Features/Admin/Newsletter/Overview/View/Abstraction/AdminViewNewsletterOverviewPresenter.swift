import FeatherWebAdmin
import Hummingbird

protocol AdminViewNewsletterOverviewPresenter: Sendable {
    func renderOverview(
        model: AdminViewNewsletterOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
