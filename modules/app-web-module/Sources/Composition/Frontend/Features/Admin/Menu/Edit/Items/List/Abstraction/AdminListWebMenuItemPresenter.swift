import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuItemPresenter: Sendable {

    func renderListPage(
        menuId: String,
        model: AdminListWebMenuItemModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse

    func renderRemovePage(
        menuId: String,
        page: Int,
        search: String?,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse
}
