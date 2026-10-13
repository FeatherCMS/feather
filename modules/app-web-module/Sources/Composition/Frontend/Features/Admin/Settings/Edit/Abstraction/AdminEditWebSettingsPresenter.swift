import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebSettingsPresenter: Sendable {
    func renderPage(
        state: WebSettingsEdit.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
