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

protocol AdminRemoveAuthMagicLinkPresenter: Sendable {

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func renderPage(
        id: String,
        credentialId: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse
}
