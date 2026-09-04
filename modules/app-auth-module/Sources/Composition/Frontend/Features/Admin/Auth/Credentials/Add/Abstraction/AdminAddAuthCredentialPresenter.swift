import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

protocol AdminAddAuthCredentialPresenter: Sendable {
    func renderPage(
        form: AuthCredentialForm.State,
        permissions: Set<String>
    ) -> HTMLResponse
    func format(error: OpenAPIRepositoryError) -> String
    func formState(
        userId: String,
        emails: [AuthCredentialIdentityOption],
        email: String,
        password: String
    ) -> AuthCredentialForm.State
}
