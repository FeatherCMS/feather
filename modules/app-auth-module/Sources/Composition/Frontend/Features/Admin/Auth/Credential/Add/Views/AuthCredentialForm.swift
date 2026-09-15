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
import WebBuilders
import WebComponents

struct AuthCredentialForm: Component {
    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: Sendable {
        var identity: FieldState
        var identityOptions: [NewAdminFormFieldSelectAutocomplete.Option]
        var email: NewAdminFormFieldInput.State
        var password: NewAdminFormFieldInput.State
        var passwordRequired: Bool
        var nonceToken: String? = nil
        var error: String?
        var success: String?

        mutating func apply(errors: [String: String]) {
            identity.error = errors[identity.key]
            email.error = errors[email.name]
            password.error = errors[password.name]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var removeHref: String?

    func html(context: inout BuilderContext) -> Form {
        var password = state.password
        password.isRequired = state.passwordRequired
        password.type = .password

        let form = NewAdminForm(action: action, nonceToken: state.nonceToken) {
            if let success = state.success { P(success).class("success") }
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            Input()
                .type(.hidden)
                .name("userId")
                .value(state.identity.value)
            context.build(
                NewAdminFormFieldSelectAutocomplete(
                    state: .init(
                        name: state.email.name,
                        label: "Auth email",
                        placeholder: "Select an email",
                        options: state.identityOptions,
                        error: state.email.error,
                        isRequired: true
                    )
                )
            )
            context.build(NewAdminFormFieldInput(state: password))
            Div {
                Div {
                    context.build(
                        NewAdminSubmitButton(submitLabel, style: .primary)
                    )
                    if let removeHref {
                        context.build(
                            NewAdminButton(
                                "Remove credential",
                                href: removeHref,
                                style: .destructive
                            )
                        )
                    }
                }
                .class("new-admin-form__actions")
            }
        }
        return context.build(form)
    }
}
