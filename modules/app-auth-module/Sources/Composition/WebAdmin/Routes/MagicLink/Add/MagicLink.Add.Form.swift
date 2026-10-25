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

extension MagicLink.Add {
    struct Form: Component {

        struct FieldState: Sendable {
            var key: String
            var label: String
            var value: String?
            var error: String?
        }

        struct CheckboxState: Sendable {
            var key: String
            var label: String
            var value: Bool
            var error: String?
        }

        struct State: Sendable {
            var credentialId: FieldState
            var emailOptions: [AdminFormFieldSelectAutocomplete.Option]
            var isPersistent: CheckboxState
            var error: String?
            var success: String?
            var nonceToken: String? = nil

            init(
                credentialId: FieldState,
                emailOptions: [AdminFormFieldSelectAutocomplete.Option] = [],
                isPersistent: CheckboxState,
                error: String? = nil,
                success: String? = nil
            ) {
                self.credentialId = credentialId
                self.emailOptions = emailOptions
                self.isPersistent = isPersistent
                self.error = error
                self.success = success
            }

            mutating func apply(
                errors: [String: String]
            ) {
                credentialId.error = errors[credentialId.key]
                isPersistent.error = errors[isPersistent.key]
            }
        }

        var state: State
        var action: String
        var submitLabel: String
        var removeHref: String? = nil
        var removeLabel: String = "Remove"

        func html(context: inout BuilderContext) -> HTML.Form {
            let form = AdminForm(action: action, nonceToken: state.nonceToken) {
                if let success = state.success {
                    P(success).class("success")
                }
                if let error = state.error {
                    P(error).class("error")
                }

                context.build(
                    AdminFormFieldSelectAutocomplete(
                        state: .init(
                            name: state.credentialId.key,
                            label: "Email",
                            placeholder: "Select an email",
                            options: state.emailOptions,
                            error: state.credentialId.error,
                            isRequired: true
                        )
                    )
                    .setAsRemoveConfirmationLabel()
                )

                context.build(
                    AdminFormFieldCheckbox(
                        state: .init(
                            name: state.isPersistent.key,
                            label: "Session persistence",
                            checkboxLabel: "Keep the user signed in",
                            isChecked: state.isPersistent.value,
                            error: state.isPersistent.error
                        )
                    )
                )

                Section {
                    Div {
                        context.build(AdminSubmitButton(submitLabel))
                        if let removeHref {
                            context.build(
                                AdminButton(
                                    removeLabel,
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
