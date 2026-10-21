import AuthAdminAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
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

protocol AdminAddAuthMagicLinkPresenter: Sendable {

    func renderPage(
        form: AuthMagicLinkForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse

    func formState(
        credentialId: String,
        emails: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema],
        isPersistent: Bool
    ) -> AuthMagicLinkForm.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
