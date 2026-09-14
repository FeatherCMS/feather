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

    func renderRemoveConfirmation(
        menuId: String,
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
