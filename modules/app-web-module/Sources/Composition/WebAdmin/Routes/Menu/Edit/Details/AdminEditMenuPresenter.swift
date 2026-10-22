import FeatherWebAdmin
import HTML
import OpenAPIRuntime

protocol AdminEditMenuPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: MenuForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
