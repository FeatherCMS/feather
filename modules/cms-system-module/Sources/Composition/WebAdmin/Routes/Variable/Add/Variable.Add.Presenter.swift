import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Variable.Add {
    enum Presenter {}
}

extension Variable.Add.Presenter {
    protocol Interface: Sendable {

        func renderAddPage(
            state: Variable.Add.Form.State
        ) async throws -> HTMLResponse

        func renderValidationError(
            input: Variable.Add.Form.Input?,
            error: ValidationError
        ) async throws -> HTMLResponse

        func renderSuccess() -> Response

        func renderAddError(
            input: Variable.Add.Form.Input?,
            error: Variable.Add.Error
        ) async throws -> HTMLResponse

        func renderUnauthorizedPage() async throws -> HTMLResponse

        func renderForbiddenPage() async throws -> HTMLResponse

        func renderInvalidNoncePage() async throws -> HTMLResponse

    }
}
