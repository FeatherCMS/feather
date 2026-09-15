import FeatherAdmin
import Hummingbird

protocol AdminRemoveSystemPermissionPresenter: Sendable {

    func renderRemovePage(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        returnTo: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminRemoveSystemPermissionError,
        cancel: String
    ) async throws -> HTMLResponse

    func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse

    func renderSuccess(location: String, count: Int) -> Response
}
