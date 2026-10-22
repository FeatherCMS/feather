import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
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

private enum CredentialFormHTML {
    static func input() -> HTML.Input {
        HTML.Input()
    }
}

extension Credential.Form {
    struct Component: WebComponents.Component {
        struct FieldState: Sendable {
            var key: String
            var label: String
            var value: String?
            var error: String?
        }

        struct State: Sendable {
            var identity: FieldState
            var identityOptions: [AdminFormFieldSelectAutocomplete.Option]
            var email: AdminFormFieldInput.State
            var password: AdminFormFieldInput.State
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

            let form = AdminForm(action: action, nonceToken: state.nonceToken) {
                if let success = state.success { P(success).class("success") }
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                CredentialFormHTML.input()
                    .type(.hidden)
                    .name("userId")
                    .value(state.identity.value)
                context.build(
                    AdminFormFieldSelectAutocomplete(
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
                context.build(AdminFormFieldInput(state: password))
                Div {
                    Div {
                        context.build(
                            AdminSubmitButton(submitLabel, style: .primary)
                        )
                        if let removeHref {
                            context.build(
                                AdminButton(
                                    "Remove credential",
                                    href: removeHref,
                                    style: .destructive
                                )
                            )
                        }
                    }
                    .class("admin-form__actions")
                }
            }
            return context.build(form)
        }
    }
}
