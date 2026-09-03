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

protocol AdminAddAuthEmailPresenter: Sendable {

    func renderPage(
        form: AuthEmailForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        identityId: String,
        isPrimary: Bool
    ) -> AuthEmailForm.State

    func breadcrumb() -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
