import FeatherWebAdmin

protocol AdminRemoveAuthSessionPresenter: Sendable {

    func renderPage(
        item: AdminRemoveItemContext,
        identityId: String
    ) async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse

    func errorPage(
        item: AdminRemoveItemContext,
        identityId: String,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse

}
