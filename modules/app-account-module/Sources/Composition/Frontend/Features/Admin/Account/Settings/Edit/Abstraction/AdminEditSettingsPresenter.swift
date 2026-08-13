import FeatherAdmin
import Hummingbird

protocol AdminEditSettingsPresenter: Sendable {

    func renderPage(
        state: SettingsEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
