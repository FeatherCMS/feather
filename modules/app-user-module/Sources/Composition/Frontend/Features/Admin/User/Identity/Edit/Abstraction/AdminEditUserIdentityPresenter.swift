import FeatherAdmin
import FeatherValidation
import Hummingbird

protocol AdminEditUserIdentityPresenter: Sendable {
    func renderEditPage(id: String, state: UserIdentityEditForm.State) async throws
        -> HTMLResponse
    func renderValidationError(
        id: String,
        input: AdminEditUserIdentityFormInput?,
        error: ValidationError,
        roleOptions: [UserIdentityEditRoleOptionModel]
    ) async throws -> HTMLResponse
    func renderEditError(
        id: String,
        input: AdminEditUserIdentityFormInput?,
        error: AdminEditUserIdentityError,
        roleOptions: [UserIdentityEditRoleOptionModel]
    ) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderUnauthorizedPage() async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
