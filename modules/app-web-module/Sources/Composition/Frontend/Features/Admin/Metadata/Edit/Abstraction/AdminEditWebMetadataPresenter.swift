import FeatherAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditWebMetadataPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: WebMetadataForm.State,
        permissions: Set<String>,
        navigationTabs: [NewAdminTabBar.Link],
        configuration: AdminWebMetadataEditConfiguration?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>,
        configuration: AdminWebMetadataEditConfiguration?
    ) async throws -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link]
}
