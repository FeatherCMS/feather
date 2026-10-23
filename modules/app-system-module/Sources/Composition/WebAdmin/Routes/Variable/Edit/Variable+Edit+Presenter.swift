import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Variable.Edit {
    enum Presenter {}
}

extension Variable.Edit.Presenter {
    protocol Interface: Sendable {

        func renderEditPage(
            id: String,
            deleteID: String,
            state: SystemVariableEditForm.State,
            permissions: Set<PermissionKey>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Variable.Edit.Error
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
            error: Variable.Edit.Error
        ) async throws -> HTMLResponse

        func renderInvalidNoncePage() async throws -> HTMLResponse

        func renderSuccess(id: String) -> Response
    }
}
