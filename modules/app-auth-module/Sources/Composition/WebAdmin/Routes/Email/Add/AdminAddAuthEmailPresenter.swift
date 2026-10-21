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
