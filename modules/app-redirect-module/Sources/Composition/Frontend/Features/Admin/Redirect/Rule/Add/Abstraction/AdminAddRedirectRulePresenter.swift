import FeatherAdmin
import FeatherValidation
import Foundation
import Hummingbird

protocol AdminAddRedirectRulePresenter: Sendable {

    func renderAddPage(
        state: RedirectRuleAddForm.State,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderValidationError(
        input: RedirectRuleAddFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse
    func renderAddError(
        input: RedirectRuleAddFormInput?,
        error: AdminAddRedirectRuleError
    ) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
