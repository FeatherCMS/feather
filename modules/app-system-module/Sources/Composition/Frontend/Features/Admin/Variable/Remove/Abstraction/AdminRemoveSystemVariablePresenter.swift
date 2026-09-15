import FeatherAdmin
import Hummingbird

protocol AdminRemoveSystemVariablePresenter: Sendable {

    func renderErrorPage(
        error: AdminRemoveSystemVariableError,
        cancel: String
    ) async throws -> HTMLResponse

    func renderInvalidNoncePage(
        cancel: String
    ) async throws -> HTMLResponse

    func renderSuccess(
        location: String,
        count: Int
    ) -> Response

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        returnTo: String?
    ) async throws -> HTMLResponse

}
