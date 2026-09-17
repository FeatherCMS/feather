import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebPagePresenter: Sendable {

    func renderListPage(
        model: AdminListWebPageModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse

    func renderRemovePage(
        page: Int,
        search: String?,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse
}
