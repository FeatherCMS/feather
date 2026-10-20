import FeatherAdmin
import FeatherValidation
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.Add {
    enum Presenter {}
}

extension WebAdmin.System.Permission.Add.Presenter {
    protocol Interface: Sendable {

        func renderAddPage(
            state: SystemPermissionAddForm.State
        ) async throws -> HTMLResponse

        func renderValidationError(
            input: SystemPermissionAddFormInput?,
            error: ValidationError
        ) async throws -> HTMLResponse

        func renderAddError(
            input: SystemPermissionAddFormInput?,
            error: WebAdmin.System.Permission.Add.Error
        ) async throws -> HTMLResponse

        func renderSuccess() -> Response

        func renderForbiddenPage() async throws -> HTMLResponse

        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
