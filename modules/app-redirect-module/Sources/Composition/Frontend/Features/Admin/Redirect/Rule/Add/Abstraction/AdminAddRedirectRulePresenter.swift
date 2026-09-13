import FeatherAdmin
import FeatherValidation
import Foundation
import Hummingbird

protocol AdminAddRedirectRulePresenter: Sendable {

    func renderAddPage(
        state: RedirectRuleForm.State,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderValidationError(input: RedirectRuleFormInput?, error: ValidationError) async throws -> HTMLResponse
    func renderAddError(input: RedirectRuleFormInput?, error: AdminAddRedirectRuleError) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
