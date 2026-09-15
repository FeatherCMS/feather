import FeatherAdmin
import Foundation

protocol AdminRemoveAuthSessionPresenter: Sendable {

    func renderPage(
        item: NewAdminRemoveItemContext,
        identityId: String
    ) async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse

    func errorPage(
        item: NewAdminRemoveItemContext,
        identityId: String,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse

    func breadcrumb(
        identityId: String,
        sessionId: String
    ) -> [NewAdminBreadcrumb.Link]
}
