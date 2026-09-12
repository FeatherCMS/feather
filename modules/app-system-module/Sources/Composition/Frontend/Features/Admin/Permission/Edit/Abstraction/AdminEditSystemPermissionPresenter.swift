import FeatherAdmin
import Hummingbird

protocol AdminEditSystemPermissionPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: SystemPermissionEditForm.State,
        isEdited: Bool
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse
}
