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

protocol AppLoginAuthPresenter: Sendable {
    func renderPage(
        form: LoginForm.State,
        message: String?
    ) -> HTMLResponse

    func formState(
        email: String,
        password: String,
        isPersistent: Bool
    ) -> LoginForm.State
}
