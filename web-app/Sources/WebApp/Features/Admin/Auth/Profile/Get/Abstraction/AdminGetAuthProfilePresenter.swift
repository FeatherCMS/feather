import Hummingbird

protocol AdminGetAuthProfilePresenter: Sendable {

    func renderPage(
        state: AuthProfileDetails.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        permissions: Set<String>
    ) -> HTMLResponse
}
