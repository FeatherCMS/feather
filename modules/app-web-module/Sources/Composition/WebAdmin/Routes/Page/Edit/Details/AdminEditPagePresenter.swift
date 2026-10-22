import FeatherWebAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditPagePresenter: Sendable {

    func renderEditPage(
        id: String,
        state: PageForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
