import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.Edit {
    enum Presenter {}
}

extension Permission.Edit.Presenter {
    protocol Interface: Sendable {

        func renderEditPage(
            id: String,
            state: Permission.Edit.Form.State,
            isEdited: Bool
        ) async throws -> HTMLResponse

        func renderValidationError(
            id: String,
            input: Permission.Edit.Form.Input?,
            error: ValidationError
        ) async throws -> HTMLResponse

        func renderEditError(
            id: String,
            input: Permission.Edit.Form.Input?,
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
