import Hummingbird

protocol AdminAddAuthCredentialPresenter: Sendable {
    func renderPage(accountID: String, form: AuthCredentialForm.State, permissions: Set<String>) -> HTMLResponse
    func format(error: OpenAPIRepositoryError) -> String
    func formState(email: String, password: String) -> AuthCredentialForm.State
}
