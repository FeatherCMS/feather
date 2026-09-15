import FeatherAdmin
import FeatherContracts
import FeatherValidation
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

    func renderValidationError(
        id: String,
        input: SystemVariableEditFormInput?,
        permissions: Set<PermissionKey>,
        error: ValidationError
    ) async throws -> HTMLResponse

    func renderEditError(
        id: String,
        input: SystemVariableEditFormInput?,
        permissions: Set<PermissionKey>,
        error: AdminEditSystemVariableError
    ) async throws -> HTMLResponse

    func renderInvalidNoncePage() async throws -> HTMLResponse

    func renderSuccess(id: String) -> Response
}
