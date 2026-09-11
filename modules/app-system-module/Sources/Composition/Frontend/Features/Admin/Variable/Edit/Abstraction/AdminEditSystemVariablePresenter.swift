import FeatherAdmin
import FeatherContracts
import Hummingbird

protocol AdminEditSystemVariablePresenter: Sendable {

    func renderEditPage(
        id: String,
        state: SystemVariableEditForm.State,
        permissions: Set<PermissionKey>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse
}
