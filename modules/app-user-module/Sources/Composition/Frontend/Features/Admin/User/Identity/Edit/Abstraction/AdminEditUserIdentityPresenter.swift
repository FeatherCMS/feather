import FeatherAdmin
import FeatherValidation
import Hummingbird

protocol AdminEditUserIdentityPresenter: Sendable {
    func renderEditPage(id: String, state: UserIdentityForm.State) async throws -> HTMLResponse
    func renderValidationError(id: String, input: AdminEditUserIdentityFormInput?, error: ValidationError) async throws -> HTMLResponse
    func renderEditError(id: String, input: AdminEditUserIdentityFormInput?, error: AdminEditUserIdentityError) async throws -> HTMLResponse
    func renderSuccess() -> Response
    func renderUnauthorizedPage() async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
