import Hummingbird

protocol AdminEditAuthAccessControlPresenter: Sendable {

    func deniedPage(
        permissions: Set<String>,
        message: String
    ) -> HTMLResponse

    func renderPage(
        state: AdminEditAuthAccessControlState,
        permissions: Set<String>,
        search: String
    ) -> HTMLResponse
}
