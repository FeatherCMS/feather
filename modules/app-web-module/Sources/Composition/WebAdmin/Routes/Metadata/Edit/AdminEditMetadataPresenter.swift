import FeatherWebAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditMetadataPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: MetadataForm.State,
        permissions: Set<String>,
        navigationTabs: [AdminTabBar.Link],
        configuration: AdminMetadataEditConfiguration?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>,
        configuration: AdminMetadataEditConfiguration?
    ) async throws -> HTMLResponse

}
