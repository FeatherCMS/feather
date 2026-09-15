import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Hummingbird

protocol AdminEditSystemPermissionPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: SystemPermissionEditForm.State,
        isEdited: Bool
    ) async throws -> HTMLResponse

    func renderValidationError(
        id: String,
        input: SystemPermissionEditFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse

    func renderEditError(
        id: String,
        input: SystemPermissionEditFormInput?,
        error: AdminEditSystemPermissionError
    ) async throws -> HTMLResponse

    func renderSuccess(id: String) -> Response

    func renderForbiddenPage() async throws -> HTMLResponse

    func renderInvalidNoncePage() async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminEditSystemPermissionError
    ) async throws -> HTMLResponse
}
