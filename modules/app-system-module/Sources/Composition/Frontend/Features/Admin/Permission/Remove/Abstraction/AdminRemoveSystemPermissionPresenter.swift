import FeatherAdmin
import Hummingbird

protocol AdminRemoveSystemPermissionPresenter: Sendable {

    func renderRemovePage(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        fromDetails: Bool,
        fromEdit: Bool
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        cancel: String
    ) async throws -> HTMLResponse
}
