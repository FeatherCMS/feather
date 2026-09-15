import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminViewRedirectOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminViewRedirectOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
