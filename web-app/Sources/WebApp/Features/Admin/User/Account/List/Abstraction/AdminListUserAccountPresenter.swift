import Hummingbird

protocol AdminListUserAccountPresenter: Sendable {

    func renderPage(
        state: UserAccountTable.State
    ) -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse

    func renderBulkRemoveConfirmation(
        selectedIds: [String],
        page: Int,
        search: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
