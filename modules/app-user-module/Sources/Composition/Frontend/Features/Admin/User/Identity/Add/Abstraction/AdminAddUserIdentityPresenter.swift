import FeatherAdmin
import FeatherValidation
import Hummingbird

protocol AdminAddUserIdentityPresenter: Sendable {
    func renderAddPage(state: UserIdentityAddForm.State) async throws
        -> HTMLResponse
    func renderValidationError(
        input: AdminAddUserIdentityFormInput?,
        error: ValidationError,
        roleOptions: [UserIdentityAddRoleOptionModel]
    ) async throws -> HTMLResponse
    func renderAddError(
        input: AdminAddUserIdentityFormInput?,
        error: AdminAddUserIdentityError,
        roleOptions: [UserIdentityAddRoleOptionModel]
    ) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderUnauthorizedPage() async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
