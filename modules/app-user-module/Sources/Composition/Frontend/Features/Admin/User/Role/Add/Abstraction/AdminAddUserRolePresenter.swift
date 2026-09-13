import FeatherAdmin
import FeatherValidation
import Foundation
import Hummingbird

protocol AdminAddUserRolePresenter: Sendable {
    func renderAddPage(state: UserRoleAddForm.State) async throws
        -> HTMLResponse
    func renderValidationError(
        input: AdminAddUserRoleFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse
    func renderAddError(
        input: AdminAddUserRoleFormInput?,
        error: AdminAddUserRoleError
    ) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderUnauthorizedPage() async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
