import FeatherWebAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditMenuItemPresenter: Sendable {

    func renderEditPage(
        menuId: String,
        id: String,
        state: MenuItemForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
