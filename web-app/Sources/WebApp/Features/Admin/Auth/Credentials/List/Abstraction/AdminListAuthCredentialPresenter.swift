import Hummingbird

protocol AdminListAuthCredentialPresenter: Sendable {
    func renderPage(
        state: AuthCredentialTable.State
    ) -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError,
        accountID: String
    ) -> HTMLResponse
}
