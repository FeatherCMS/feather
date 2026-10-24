import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.Add {
    enum Presenter {}
}

extension Identity.Add.Presenter {
    protocol Interface: Sendable {
        func renderAddPage(state: Identity.Add.Form.Component.State)
            async throws
            -> HTMLResponse
        func renderValidationError(
            input: Identity.Add.Form.Input?,
            error: ValidationError,
            roleOptions: [Identity.Add.RoleOption]
        ) async throws -> HTMLResponse
        func renderAddError(
            input: Identity.Add.Form.Input?,
            error: Identity.Add.Error,
            roleOptions: [Identity.Add.RoleOption]
        ) async throws -> HTMLResponse
        func renderSuccess() -> Response
        func renderUnauthorizedPage() async throws -> HTMLResponse
        func renderForbiddenPage() async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
