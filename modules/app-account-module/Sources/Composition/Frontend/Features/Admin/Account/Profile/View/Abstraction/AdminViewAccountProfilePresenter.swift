import FeatherAdmin

protocol AdminViewAccountProfilePresenter: Sendable {

    func renderPage(
        state: AccountProfileDetails.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderDeniedPage(
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
