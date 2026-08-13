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

protocol AdminAddAuthMagicLinkPresenter: Sendable {

    func renderPage(
        form: AuthMagicLinkForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        credentialId: String,
        isPersistent: Bool
    ) -> AuthMagicLinkForm.State

    func breadcrumb() -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
