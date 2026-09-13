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

    func breadcrumb() -> [NewAdminBreadcrumb.Link]

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
