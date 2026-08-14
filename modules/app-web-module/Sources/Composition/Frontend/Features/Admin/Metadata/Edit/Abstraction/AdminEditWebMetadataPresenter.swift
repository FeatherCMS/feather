import FeatherAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditWebMetadataPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: WebMetadataForm.State,
        isEdited: Bool,
        permissions: Set<String>,
        navigationTabs: [AdminPillTabs.Link],
        configuration: AdminWebMetadataEditConfiguration?
    ) -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>,
        configuration: AdminWebMetadataEditConfiguration?
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
