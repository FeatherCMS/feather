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

protocol AdminEditAuthMagicLinkPresenter: Sendable {

    func formState(
        credentialId: String,
        emails: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema],
        isPersistent: Bool
    ) -> AuthMagicLinkForm.State

    func renderPage(
        id: String,
        isEdited: Bool,
        form: AuthMagicLinkForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}

extension AdminEditAuthMagicLinkPresenter {
    func formState(
        credentialId: String,
        isPersistent: Bool
    ) -> AuthMagicLinkForm.State {
        formState(
            credentialId: credentialId,
            emails: [],
            isPersistent: isPersistent
        )
    }
}
