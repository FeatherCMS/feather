import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebPagePresenter: Sendable {

    func renderListPage(
        model: AdminListWebPageModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse
}
