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

extension Login.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            form: Login.Form.Component.State,
            message: String?
        ) -> HTMLResponse

        func formState(
            email: String,
            password: String,
            isPersistent: Bool,
            redirectPath: String,
            turnstileSiteKey: String?
        ) -> Login.Form.Component.State
    }
}
