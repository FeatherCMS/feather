import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Add {
    enum Presenter {}
}

extension RedirectModule.Rule.Add.Presenter {
    protocol Interface: Sendable {
        func renderAddPage(
            state: RedirectModule.Rule.Add.Form.State,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

        func renderValidationError(
            input: RedirectModule.Rule.Add.Form.Input?,
            error: ValidationError
        ) async throws -> HTMLResponse
        func renderAddError(
            input: RedirectModule.Rule.Add.Form.Input?,
            error: RedirectModule.Rule.Add.Error
        ) async throws -> HTMLResponse
        func renderSuccess() -> Response
        func renderForbiddenPage() async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
