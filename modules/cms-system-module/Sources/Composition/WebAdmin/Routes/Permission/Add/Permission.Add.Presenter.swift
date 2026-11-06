import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.Add {
    enum Presenter {}
}

extension Permission.Add.Presenter {
    protocol Interface: Sendable {

        func renderAddPage(
            state: Permission.Add.Form.State
        ) async throws -> HTMLResponse

        func renderValidationError(
            input: Permission.Add.Form.Input?,
            error: ValidationError
        ) async throws -> HTMLResponse

        func renderAddError(
            input: Permission.Add.Form.Input?,
            error: Permission.Add.Error
        ) async throws -> HTMLResponse

        func renderSuccess() -> Response

        func renderForbiddenPage() async throws -> HTMLResponse

        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
