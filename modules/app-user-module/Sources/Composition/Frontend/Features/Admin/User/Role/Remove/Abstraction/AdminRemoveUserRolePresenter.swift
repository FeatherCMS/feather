import FeatherAdmin
import Hummingbird

protocol AdminRemoveUserRolePresenter: Sendable {
    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse
    func renderErrorPage(error: AdminRemoveUserRoleError, cancel: String)
        async throws -> HTMLResponse
    func renderSuccess(location: String, count: Int) -> Response
    func renderUnauthorizedPage() async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
}
