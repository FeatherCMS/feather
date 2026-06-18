import Foundation

protocol AdminRemoveUserAccountPresenter: Sendable {

    func renderPage(
        state: UserAccountConfirmation.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func errorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse

    func errorState(
        id: String,
        error: OpenAPIRepositoryError
    ) -> UserAccountError.State

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
