import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminGetRedirectOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminGetRedirectOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
