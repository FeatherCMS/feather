import FeatherWebApp
import FeatherWebShared
import Foundation

extension Login.Presenter {
    struct Default: Interface {
        let templateRenderer: any TemplateRenderer
        let routes: Login.Router.Routes

        func renderPage(
            form: Login.Form.State,
            message: String?
        ) throws -> WebAppHTMLResponse {
            var components = URLComponents()
            components.path = routes.login.path
            if form.redirectPath != "/" {
                components.queryItems = [
                    URLQueryItem(name: "redirect", value: form.redirectPath)
                ]
            }
            let action = components.string ?? routes.login.path
            return WebAppHTMLResponse(
                content: try templateRenderer.render(
                    template: "pages/login",
                    context: [
                        "action": action,
                        "email": form.email,
                        "emailError": form.emailError ?? "",
                        "hasEmailError": form.emailError?.isEmpty == false,
                        "hasMessage": message?.isEmpty == false,
                        "hasPasswordError": form.passwordError?.isEmpty
                            == false,
                        "hasTurnstile": form.turnstileSiteKey?.isEmpty == false,
                        "isPersistent": form.isPersistent,
                        "message": message ?? "",
                        "password": form.password,
                        "passwordError": form.passwordError ?? "",
                        "redirectPath": form.redirectPath,
                        "turnstileSiteKey": form.turnstileSiteKey ?? "",
                    ]
                )
            )
        }

        func formState(
            email: String = "",
            password: String = "",
            isPersistent: Bool = true,
            redirectPath: String = "/",
            turnstileSiteKey: String? = nil
        ) -> Login.Form.State {
            .init(
                email: email,
                password: password,
                emailError: nil,
                passwordError: nil,
                isPersistent: isPersistent,
                redirectPath: redirectPath,
                turnstileSiteKey: turnstileSiteKey
            )
        }
    }
}
