import Foundation

protocol AdminGetUserAccountPresenter: Sendable {

    func renderPage(
        model: AdminGetUserAccountModel,
        permissions: Set<String>,
        isSessionRemoved: Bool
    ) -> HTMLResponse

    func renderSessionsBulkRemoveConfirmation(
        accountId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse

    func errorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
