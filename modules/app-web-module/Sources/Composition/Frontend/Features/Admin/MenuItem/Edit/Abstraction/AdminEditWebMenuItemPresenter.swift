import FeatherAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditWebMenuItemPresenter: Sendable {

    func renderEditPage(
        menuId: String,
        id: String,
        state: WebMenuItemForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb(
        menuId: String,
        id: String
    ) -> [NewAdminBreadcrumb.Link]
}
