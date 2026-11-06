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

extension Email.Form {
    struct Component: WebComponents.Component {

        struct FieldState: Sendable {
            var key: String
            var label: String
            var value: String?
            var error: String?
        }

        struct State: Sendable {
            var identityId: FieldState
            var email: FieldState
            var error: String?
            var success: String?
            var nonceToken: String? = nil

            init(
                identityId: FieldState,
                email: FieldState = .init(
                    key: "email",
                    label: "Email address",
                    value: "",
                    error: nil
                ),
                error: String? = nil,
                success: String? = nil
            ) {
                self.identityId = identityId
                self.email = email
                self.error = error
                self.success = success
            }

            mutating func apply(
                errors: [String: String]
            ) {
                identityId.error = errors[identityId.key]
                email.error = errors[email.key]
            }
        }

        var state: State
        var action: String
        var submitLabel: String

        func html(context: inout BuilderContext) -> Form {
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
                            name: state.identityId.key,
                            label: state.identityId.label,
                            placeholder: "Select a user identity",
                            options: [],
                            selectedValues: state.identityId.value.map { [$0] } ?? [],
                            error: state.identityId.error,
                            isRequired: true,
                            remoteSourceURL: AuthLookup.url(type: "identity")
                        )
                    )
                )

                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: state.email.key,
                            label: state.email.label,
                            value: state.email.value,
                            error: state.email.error,
                            type: .email,
                            isRequired: true
                        )
                    )
                    .setAsRemoveConfirmationLabel()
                )

                Section {
                    Div {
                        context.build(AdminSubmitButton(submitLabel))
                    }
                    .class("admin-form__actions")
                }
            }
            return context.build(form)
        }
    }
}
