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

protocol AdminEditAuthCredentialPresenter: Sendable {
    func renderPage(
        id: String,
        form: AuthCredentialForm.State,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse
    func formState(
        userId: String,
        emails: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema],
        email: String,
        password: String
    ) -> AuthCredentialForm.State
    func format(error: OpenAPIRepositoryError) -> String
}
