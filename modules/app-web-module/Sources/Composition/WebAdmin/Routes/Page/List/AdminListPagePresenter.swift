import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListPagePresenter: Sendable {

    func renderListPage(
        model: AdminListPageModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse
}
