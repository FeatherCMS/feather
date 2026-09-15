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

struct AuthMagicLinkForm: Component {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct CheckboxState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: Bool
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var credentialId: FieldState
        var emailOptions: [NewAdminFormFieldSelectAutocomplete.Option]
        var isPersistent: CheckboxState
        var error: String?
        var success: String?
        var nonceToken: String? = nil

        init(
            credentialId: FieldState,
            emailOptions: [NewAdminFormFieldSelectAutocomplete.Option] = [],
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

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: state.nonceToken) {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            context.render(
                NewAdminFormFieldSelectAutocomplete(
                    state: .init(
                        name: state.credentialId.key,
                        label: "Email",
                        placeholder: "Select an email",
                        options: state.emailOptions,
                        error: state.credentialId.error,
                        isRequired: true
                    )
                )
            )

            context.render(
                NewAdminFormFieldCheckbox(
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
                    context.render(NewAdminSubmitButton(submitLabel))
                    if let removeHref {
                        context.render(
                            NewAdminButton(
                                removeLabel,
                                href: removeHref,
                                style: .destructive
                            )
                        )
                    }
                }
                .class("new-admin-form__actions")
            }
        }
        return context.render(form)
    }
}
