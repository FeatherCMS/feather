import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Edit {
    enum Presenter {}
}

extension RedirectModule.Rule.Edit.Presenter {
    protocol Interface: Sendable {

        func renderEditPage(
            id: String,
            state: RedirectModule.Rule.Edit.Form.State,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

        func renderValidationError(
            id: String,
            input: RedirectModule.Rule.Edit.Form.Input?,
            error: ValidationError
        ) async throws -> HTMLResponse
        func renderEditError(
            id: String,
            input: RedirectModule.Rule.Edit.Form.Input?,
            error: RedirectModule.Rule.Edit.Interactor.Error
        ) async throws -> HTMLResponse
        func renderSuccess(id: String) -> Response
        func renderForbiddenPage() async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
