import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.Edit.Presenter {
    protocol Interface: Sendable {
        func renderEditPage(
            id: String,
            state: Identity.Edit.FormComponent.State
        )
            async throws
            -> HTMLResponse
        func renderValidationError(
            id: String,
            input: Identity.Edit.FormInput?,
            error: ValidationError,
            roleOptions: [Identity.Edit.RoleOption]
        ) async throws -> HTMLResponse
        func renderEditError(
            id: String,
            input: Identity.Edit.FormInput?,
            error: Identity.Edit.Error,
            roleOptions: [Identity.Edit.RoleOption]
        ) async throws -> HTMLResponse
        func renderSuccess(id: String) -> Response
        func renderUnauthorizedPage() async throws -> HTMLResponse
        func renderForbiddenPage() async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
