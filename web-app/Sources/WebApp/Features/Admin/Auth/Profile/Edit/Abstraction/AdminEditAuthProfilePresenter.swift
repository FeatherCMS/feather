import Hummingbird

protocol AdminEditAuthProfilePresenter: Sendable {

    func renderPage(
        state: AuthProfileEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        permissions: Set<String>
    ) -> HTMLResponse
}
