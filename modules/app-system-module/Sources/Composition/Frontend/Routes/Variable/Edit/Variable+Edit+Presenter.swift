import FeatherAdmin
import FeatherModuleKit
import FeatherValidation
import Hummingbird
import SystemModule

extension WebAdmin.System.Variable.Edit {
    enum Presenter {}
}

extension WebAdmin.System.Variable.Edit.Presenter {
    protocol Interface: Sendable {

        func renderEditPage(
            id: String,
            deleteID: String,
            state: SystemVariableEditForm.State,
            permissions: Set<PermissionKey>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: WebAdmin.System.Variable.Edit.Error
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
            error: WebAdmin.System.Variable.Edit.Error
        ) async throws -> HTMLResponse

        func renderInvalidNoncePage() async throws -> HTMLResponse

        func renderSuccess(id: String) -> Response
    }
}
