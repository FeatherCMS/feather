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
import WebStandards

protocol AdminListAuthCredentialPresenter: Sendable {
    func renderPage(
        state: AuthCredentialTable.State
    ) -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse
}
