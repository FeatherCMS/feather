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
import WebComponents
import WebBuilders

protocol AdminGetAuthHomePresenter: Sendable {

    func renderHome(
        model: AdminGetAuthHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
