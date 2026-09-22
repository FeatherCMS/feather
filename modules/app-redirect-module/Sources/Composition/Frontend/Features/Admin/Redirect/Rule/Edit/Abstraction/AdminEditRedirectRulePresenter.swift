import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird

protocol AdminEditRedirectRulePresenter: Sendable {

    func renderEditPage(
        id: String,
        state: RedirectRuleEditForm.State,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderValidationError(
        id: String,
        input: RedirectRuleEditFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse
    func renderEditError(
        id: String,
        input: RedirectRuleEditFormInput?,
        error: AdminEditRedirectRuleError
    ) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
