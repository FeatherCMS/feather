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
import WebStandards

protocol AdminEditAuthMagicLinkPresenter: Sendable {

    func formState(
        credentialId: String,
        emails: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema],
        isPersistent: Bool
    ) -> AuthMagicLinkForm.State

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func renderPage(
        id: String,
        isEdited: Bool,
        form: AuthMagicLinkForm.State,
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
