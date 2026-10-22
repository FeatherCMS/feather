import AuthAppAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebApp
import Hummingbird
import OpenAPIRuntime

extension Login.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            form: Login.Form.State,
            message: String?
        ) throws -> WebAppHTMLResponse

        func formState(
            email: String,
            password: String,
            isPersistent: Bool,
            redirectPath: String,
            turnstileSiteKey: String?
        ) -> Login.Form.State
    }
}
