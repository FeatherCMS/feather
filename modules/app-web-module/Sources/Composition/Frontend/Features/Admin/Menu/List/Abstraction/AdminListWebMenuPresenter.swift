import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuPresenter: Sendable {

    func renderListPage(
        model: AdminListWebMenuModel,
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
