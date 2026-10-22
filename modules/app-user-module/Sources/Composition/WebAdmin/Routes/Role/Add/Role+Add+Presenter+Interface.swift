import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import UserModule

extension Role.Add.Presenter {
    protocol Interface: Sendable {
        func renderAddPage(state: Role.Add.FormComponent.State) async throws
            -> HTMLResponse
        func renderValidationError(
            input: Role.Add.FormInput?,
            error: ValidationError
        ) async throws -> HTMLResponse
        func renderAddError(
            input: Role.Add.FormInput?,
            error: Role.Add.Error
        ) async throws -> HTMLResponse
        func renderSuccess() -> Response
        func renderUnauthorizedPage() async throws -> HTMLResponse
        func renderForbiddenPage() async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
