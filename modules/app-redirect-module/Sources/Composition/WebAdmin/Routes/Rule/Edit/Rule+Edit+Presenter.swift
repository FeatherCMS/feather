import RedirectModule
import RedirectApplication
import FeatherWebAdmin
import FeatherValidation
import Hummingbird

extension RedirectModule.Rule.Edit {
    enum Presenter {}
}

extension RedirectModule.Rule.Edit.Presenter {
    protocol Interface: Sendable {

    func renderEditPage(
        id: String,
        state: RedirectRuleEditForm.State,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

    func renderValidationError(
        id: String,
        input: RedirectRuleEditFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse
    func renderEditError(
        id: String,
        input: RedirectRuleEditFormInput?,
        error: RedirectModule.Rule.Edit.Error
    ) async throws -> HTMLResponse
    func renderSuccess(id: String) -> Response
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
