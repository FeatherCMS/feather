import Hummingbird

protocol AdminRemoveAuthCredentialPresenter: Sendable {
    func renderPage(model: AuthCredentialDetailsModel, permissions: Set<String>) -> HTMLResponse
    func renderError(id: String, error: OpenAPIRepositoryError, permissions: Set<String>) -> HTMLResponse
}
