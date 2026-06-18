import Foundation

protocol AdminRemoveUserAccountSessionPresenter: Sendable {

    func renderPage(
        state: UserAccountSessionConfirmation.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func errorPage(
        accountId: String,
        sessionId: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        accountId: String,
        sessionId: String
    ) -> AdminBreadcrumb.State
}
