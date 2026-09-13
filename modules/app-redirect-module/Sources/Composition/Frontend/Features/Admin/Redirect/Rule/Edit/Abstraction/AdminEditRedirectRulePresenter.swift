import FeatherAdmin
import Foundation
import HTML
import FeatherValidation
import Hummingbird

protocol AdminEditRedirectRulePresenter: Sendable {

    func renderEditPage(
        id: String,
        state: RedirectRuleForm.State,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderValidationError(id: String, input: RedirectRuleFormInput?, error: ValidationError) async throws -> HTMLResponse
    func renderEditError(id: String, input: RedirectRuleFormInput?, error: AdminEditRedirectRuleError) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
