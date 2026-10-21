import RedirectModule
import FeatherWebAdmin
import FeatherValidation
import Hummingbird
import RedirectApplication

extension RedirectModule.Rule.Add {
    enum Presenter {}
}

extension RedirectModule.Rule.Add.Presenter {
    protocol Interface: Sendable {
    func renderAddPage(
        state: RedirectRuleAddForm.State,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

    func renderValidationError(
        input: RedirectRuleAddFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse
    func renderAddError(
        input: RedirectRuleAddFormInput?,
        error: RedirectModule.Rule.Add.Error
    ) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
