import Hummingbird

protocol AdminListAuthCredentialAccountPresenter: Sendable {
    func renderPage(
        state: AuthCredentialAccountTable.State
    ) -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse
}
