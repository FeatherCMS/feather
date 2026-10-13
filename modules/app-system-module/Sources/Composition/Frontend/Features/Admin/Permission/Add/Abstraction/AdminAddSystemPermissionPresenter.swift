import FeatherAdmin
import FeatherValidation
import Hummingbird

protocol AdminAddSystemPermissionPresenter: Sendable {

    func renderAddPage(
        state: SystemPermissionAddForm.State
    ) async throws -> HTMLResponse

    func renderValidationError(
        input: SystemPermissionAddFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse

    func renderAddError(
        input: SystemPermissionAddFormInput?,
        error: AdminAddSystemPermissionError
    ) async throws -> HTMLResponse

    func renderSuccess() -> Response

    func renderForbiddenPage() async throws -> HTMLResponse

    func renderInvalidNoncePage() async throws -> HTMLResponse
}
