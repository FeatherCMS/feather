import AuthAdminAPI
import FeatherWebShared
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

protocol AdminAddAuthCredentialPresenter: Sendable {
    func renderPage(
        form: AuthCredentialForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse
    func format(error: OpenAPIRepositoryError) -> String
    func formState(
        userId: String,
        emails: [AuthCredentialIdentityOption],
        email: String,
        password: String
    ) -> AuthCredentialForm.State
}
