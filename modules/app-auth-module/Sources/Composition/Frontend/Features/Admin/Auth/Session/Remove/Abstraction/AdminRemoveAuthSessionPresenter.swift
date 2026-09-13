import FeatherAdmin
import Foundation

protocol AdminRemoveAuthSessionPresenter: Sendable {

    func renderPage(
        state: AuthSessionRemoveConfirmation.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse

    func errorPage(
        identityId: String,
        sessionId: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb(
        identityId: String,
        sessionId: String
    ) -> [NewAdminBreadcrumb.Link]
}
