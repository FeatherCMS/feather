import FeatherAdmin
import FeatherValidation
import Hummingbird

protocol AdminAddUserIdentityPresenter: Sendable {
    func renderAddPage(state: UserIdentityForm.State) async throws
        -> HTMLResponse
    func renderValidationError(
        input: AdminAddUserIdentityFormInput?,
        error: ValidationError,
        roleOptions: [UserIdentityRoleOptionModel]
    ) async throws -> HTMLResponse
    func renderAddError(
        input: AdminAddUserIdentityFormInput?,
        error: AdminAddUserIdentityError,
        roleOptions: [UserIdentityRoleOptionModel]
    ) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderUnauthorizedPage() async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
