import FeatherAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditWebMenuItemPresenter: Sendable {

    func renderEditPage(
        menuId: String,
        id: String,
        state: WebMenuItemForm.State,
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
