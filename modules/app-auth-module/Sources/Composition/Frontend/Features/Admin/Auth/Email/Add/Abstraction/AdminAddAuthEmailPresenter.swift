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
import WebBuilders
import WebComponents

protocol AdminAddAuthEmailPresenter: Sendable {

    func renderPage(
        form: AuthEmailForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func renderForbiddenPage() async throws -> HTMLResponse

    func formState(
        identityId: String,
        identities: [AuthCredentialIdentityOption]
    ) -> AuthEmailForm.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}

extension AdminAddAuthEmailPresenter {
    func formState(
        identityId: String
    ) -> AuthEmailForm.State {
        formState(identityId: identityId, identities: [])
    }
}
