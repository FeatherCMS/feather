import FeatherAdmin

protocol AdminEditAccountProfilePresenter: Sendable {

    func renderPage(
        state: AccountProfileEdit.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderDeniedPage(
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
