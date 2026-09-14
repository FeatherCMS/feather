import FeatherAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditWebPagePresenter: Sendable {

    func renderEditPage(
        id: String,
        state: WebPageForm.State,
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
