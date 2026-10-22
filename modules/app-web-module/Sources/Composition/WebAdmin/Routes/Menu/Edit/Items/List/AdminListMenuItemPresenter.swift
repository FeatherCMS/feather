import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListMenuItemPresenter: Sendable {

    func renderListPage(
        menuId: String,
        model: AdminListMenuItemModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse
}
