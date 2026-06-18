import Hummingbird

protocol AdminListAuthMagicLinkPresenter: Sendable {

    func renderPage(
        state: AuthMagicLinkTable.State
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
