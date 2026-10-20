import FeatherAdmin
import FeatherValidation
import Hummingbird
import SystemModule

extension Variable.Add {
    enum Presenter {}
}

extension Variable.Add.Presenter {
    protocol Interface: Sendable {

        func renderAddPage(
            state: SystemVariableAddForm.State
        ) async throws -> HTMLResponse

        func renderValidationError(
            input: SystemVariableAddFormInput?,
            error: ValidationError
        ) async throws -> HTMLResponse

        func renderSuccess() -> Response

        func renderAddError(
            input: SystemVariableAddFormInput?,
            error: Variable.Add.Error
        ) async throws -> HTMLResponse

        func renderUnauthorizedPage() async throws -> HTMLResponse

        func renderForbiddenPage() async throws -> HTMLResponse

        func renderInvalidNoncePage() async throws -> HTMLResponse

    }
}
