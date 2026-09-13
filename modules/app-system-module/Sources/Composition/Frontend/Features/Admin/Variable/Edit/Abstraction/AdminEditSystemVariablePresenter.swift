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
        error: AdminEditSystemVariableError
    ) async throws -> HTMLResponse
}
