import Hummingbird

protocol AdminEditWebSettingsPresenter: Sendable {
    func renderPage(
        state: WebSettingsEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
