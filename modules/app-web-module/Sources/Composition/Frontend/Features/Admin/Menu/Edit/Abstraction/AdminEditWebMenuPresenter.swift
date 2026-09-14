import FeatherAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditWebMenuPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: WebMenuForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link]
}
