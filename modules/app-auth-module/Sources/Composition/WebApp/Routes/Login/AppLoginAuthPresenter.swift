import AuthAppAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebApp
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
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
