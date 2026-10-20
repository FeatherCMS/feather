import AuthAdminAPI
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

protocol AdminEditAuthCredentialPresenter: Sendable {
    func renderPage(
        id: String,
        form: AuthCredentialForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func formState(
        userId: String,
        emails: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema],
        email: String,
        password: String
    ) -> AuthCredentialForm.State
    func format(error: OpenAPIRepositoryError) -> String
}
