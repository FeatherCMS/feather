import Hummingbird

protocol AdminEditAuthSettingsPresenter: Sendable {

    func renderPage(
        state: AuthSettingsEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
