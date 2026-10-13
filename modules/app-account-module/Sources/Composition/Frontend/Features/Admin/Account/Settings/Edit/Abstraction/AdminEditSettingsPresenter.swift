import FeatherAdmin

protocol AdminEditSettingsPresenter: Sendable {

    func renderPage(
        state: SettingsEdit.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
