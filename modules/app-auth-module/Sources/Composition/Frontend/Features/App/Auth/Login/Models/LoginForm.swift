import FeatherAdmin
import HTML
import WebBuilders
import WebComponents

struct LoginForm: Component {

    struct State {
        var email: NewAdminFormFieldInput.State
        var password: NewAdminFormFieldInput.State
        var isPersistent: NewAdminFormFieldCheckbox.State
        var redirectPath: String

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

        let form = NewAdminForm(
            action: action,
            hiddenFields: [
                .init(name: "redirect", value: state.redirectPath)
            ]
        ) {
            if let message {
                P(message).class("new-admin-form__error")
            }
            context.build(NewAdminFormFieldInput(state: state.email))
            context.build(NewAdminFormFieldInput(state: state.password))
            context.build(
                NewAdminFormFieldCheckbox(state: state.isPersistent)
            )
            Div {
                context.build(NewAdminSubmitButton("Sign in"))
            }
            .class("new-admin-form__actions")
        }
        return context.build(form)
    }
}
