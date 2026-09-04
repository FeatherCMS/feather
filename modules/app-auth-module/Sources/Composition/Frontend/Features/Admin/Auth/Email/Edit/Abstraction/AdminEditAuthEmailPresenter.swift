import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
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

protocol AdminEditAuthEmailPresenter: Sendable {

    func formState(
        identityId: String,
        identities: [AuthCredentialIdentityOption],
        email: String
    ) -> AuthEmailForm.State

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func renderPage(
        id: String,
        isEdited: Bool,
        form: AuthEmailForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}

extension AdminEditAuthEmailPresenter {
    func formState(
        identityId: String,
        email: String = ""
    ) -> AuthEmailForm.State {
        formState(identityId: identityId, identities: [], email: email)
    }
}
