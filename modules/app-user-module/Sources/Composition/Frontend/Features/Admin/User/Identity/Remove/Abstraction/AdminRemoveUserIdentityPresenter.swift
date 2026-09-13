import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminRemoveUserIdentityPresenter: Sendable {
    func renderRemovePage(id: String, name: String) async throws -> HTMLResponse
    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        returnTo: String?
    ) async throws -> HTMLResponse
    func renderErrorPage(error: AdminRemoveUserIdentityError, cancel: String)
        async throws -> HTMLResponse
    func renderSuccess(location: String, count: Int) -> Response
    func renderUnauthorizedPage() async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
}
