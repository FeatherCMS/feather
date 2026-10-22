import FeatherWebAdmin
import FeatherWebApp
import HTML
import WebComponents

extension Login.Presenter {
    struct Default: Interface {
        func renderPage(
            form: Login.Form.Component.State,
            message: String?
        ) -> HTMLResponse {
            var buildContext = BuilderContext()
            let component = AdminHTML(
                title: "Login",
                body: .init(
                    content: Login.Page(
                        state: .init(
                            form: form,
                            message: message
                        )
                    ),
                    showsFooter: false,
                    allowsPasswordManagerAutofill: true
                ),
                stylesheetPath: nil
            )
            return .init(buildContext.build(component))
        }

        func formState(
            email: String = "",
            password: String = "",
            isPersistent: Bool = true,
            redirectPath: String = "/",
            turnstileSiteKey: String? = nil
        ) -> Login.Form.Component.State {
            .init(
                email: .init(
                    name: "email",
                    label: "Email address",
                    value: email,
                    error: nil,
                    type: .email,
                    isRequired: true
                ),
                password: .init(
                    name: "password",
                    label: "Password",
                    value: password,
                    error: nil,
                    type: .password,
                    isRequired: true
                ),
                isPersistent: .init(
                    name: "is_persistent",
                    label: "Session",
                    checkboxLabel: "Keep me signed in",
                    isChecked: isPersistent
                ),
                redirectPath: redirectPath,
                turnstileSiteKey: turnstileSiteKey
            )
        }
    }
}
