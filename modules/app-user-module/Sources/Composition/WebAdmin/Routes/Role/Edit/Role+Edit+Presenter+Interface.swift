import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import UserModule

extension Role.Edit.Presenter {
    protocol Interface: Sendable {
        func renderEditPage(id: String, state: Role.Edit.FormComponent.State)
            async throws
            -> HTMLResponse
        func renderValidationError(
            id: String,
            input: Role.Edit.FormInput?,
            error: ValidationError
        ) async throws -> HTMLResponse
        func renderEditError(
            id: String,
            input: Role.Edit.FormInput?,
            error: Role.Edit.Error
        ) async throws -> HTMLResponse
        func renderSuccess(id: String) -> Response
        func renderUnauthorizedPage() async throws -> HTMLResponse
        func renderForbiddenPage() async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
