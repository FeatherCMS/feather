import Hummingbird

protocol AdminEditAuthCredentialPresenter: Sendable {
    func renderPage(id: String, form: AuthCredentialForm.State, permissions: Set<String>) -> HTMLResponse
    func renderError(id: String, error: OpenAPIRepositoryError, permissions: Set<String>) -> HTMLResponse
    func formState(email: String, password: String) -> AuthCredentialForm.State
    func format(error: OpenAPIRepositoryError) -> String
}
