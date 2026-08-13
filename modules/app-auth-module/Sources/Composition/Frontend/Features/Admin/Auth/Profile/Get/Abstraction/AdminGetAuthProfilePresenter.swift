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

protocol AdminGetAuthProfilePresenter: Sendable {

    func renderPage(
        state: AuthProfileDetails.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        permissions: Set<String>
    ) -> HTMLResponse
}
