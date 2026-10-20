import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
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

protocol AppLoginAuthPresenter: Sendable {
    func renderPage(
        form: LoginForm.State,
        message: String?
    ) -> HTMLResponse

    func formState(
        email: String,
        password: String,
        isPersistent: Bool,
        redirectPath: String,
        turnstileSiteKey: String?
    ) -> LoginForm.State
}
