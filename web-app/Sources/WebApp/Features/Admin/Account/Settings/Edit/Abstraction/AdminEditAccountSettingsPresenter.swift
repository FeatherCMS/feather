import Hummingbird

protocol AdminEditAccountSettingsPresenter: Sendable {

    func renderPage(
        state: AccountSettingsEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
