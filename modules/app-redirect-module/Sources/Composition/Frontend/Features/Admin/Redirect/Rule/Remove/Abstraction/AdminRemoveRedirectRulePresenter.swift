import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminRemoveRedirectRulePresenter: Sendable {

    func renderRemovePage(
        id: String,
        source: String,
        returnTo: String?
    ) async throws -> HTMLResponse

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        returnTo: String?
    ) async throws -> HTMLResponse
    func renderErrorPage(error: AdminRemoveRedirectRuleError, cancel: String)
        async throws -> HTMLResponse
    func renderSuccess(location: String, count: Int) -> Response
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
}
