import FeatherWebAdmin
import FeatherModuleKit
import FeatherValidation
import Hummingbird
import SystemModule

extension Permission.Edit {
    enum Presenter {}
}

extension Permission.Edit.Presenter {
    protocol Interface: Sendable {

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
            error: Permission.Edit.Error
        ) async throws -> HTMLResponse

        func renderSuccess(id: String) -> Response

        func renderForbiddenPage() async throws -> HTMLResponse

        func renderInvalidNoncePage() async throws -> HTMLResponse

        func renderErrorPage(
            error: Permission.Edit.Error
        ) async throws -> HTMLResponse
    }
}
