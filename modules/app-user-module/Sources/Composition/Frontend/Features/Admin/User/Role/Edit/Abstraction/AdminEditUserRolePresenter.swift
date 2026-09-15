import FeatherAdmin
import FeatherValidation
import Foundation
import Hummingbird

protocol AdminEditUserRolePresenter: Sendable {
    func renderEditPage(id: String, state: UserRoleEditForm.State) async throws
        -> HTMLResponse
    func renderValidationError(
        id: String,
        input: AdminEditUserRoleFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse
    func renderEditError(
        id: String,
        input: AdminEditUserRoleFormInput?,
        error: AdminEditUserRoleError
    ) async throws -> HTMLResponse
    func renderSuccess(id: String) -> Response
    func renderUnauthorizedPage() async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
