import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.Add.Presenter {
    protocol Interface: Sendable {
        func renderAddPage(state: Identity.Add.FormComponent.State) async throws
            -> HTMLResponse
        func renderValidationError(
            input: Identity.Add.FormInput?,
            error: ValidationError,
            roleOptions: [Identity.Add.RoleOption]
        ) async throws -> HTMLResponse
        func renderAddError(
            input: Identity.Add.FormInput?,
            error: Identity.Add.Error,
            roleOptions: [Identity.Add.RoleOption]
        ) async throws -> HTMLResponse
        func renderSuccess() -> Response
        func renderUnauthorizedPage() async throws -> HTMLResponse
        func renderForbiddenPage() async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
