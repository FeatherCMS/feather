import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminViewWebOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
