import FeatherWebAdmin
import FeatherWebApp
import HTML
import SGML
import WebBuilders
import WebComponents

struct LoginForm: Component {

    struct State {
        var email: AdminFormFieldInput.State
        var password: AdminFormFieldInput.State
        var isPersistent: AdminFormFieldCheckbox.State
        var redirectPath: String
        var turnstileSiteKey: String?

        mutating func apply(
            errors: [String: String]
        ) {
            email.error = errors[email.name]
        }
    }

    var state: State
    var message: String?

    func html(context: inout BuilderContext) -> Form {
        let action =
            state.redirectPath == "/"
            ? "/login/"
            : "/login/?redirect=\(state.redirectPath.queryEncoded())"

        let form = AdminForm(
            action: action,
            hiddenFields: [
                .init(name: "redirect", value: state.redirectPath)
            ]
        ) {
            if let message {
                P(message).class("admin-form__error")
            }
            context.build(AdminFormFieldInput(state: state.email))
            context.build(AdminFormFieldInput(state: state.password))
            context.build(
                AdminFormFieldCheckbox(state: state.isPersistent)
            )
            if let siteKey = state.turnstileSiteKey, !siteKey.isEmpty {
                Div {}.class("cf-turnstile").data("sitekey", siteKey)
                Script()
                    .src(
                        "https://challenges.cloudflare.com/turnstile/v0/api.js"
                    )
                    .async()
                    .defer()
            }
            Div {
                context.build(AdminSubmitButton("Sign in"))
            }
            .class("admin-form__actions")
        }
        return context.build(form)
    }
}
