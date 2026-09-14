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

struct AuthEmailForm: Component {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var identityId: FieldState
        var identityOptions: [NewAdminAutocompleteField.Option]
        var email: FieldState
        var error: String?
        var success: String?
        var nonceToken: String? = nil

        init(
            identityId: FieldState,
            identityOptions: [NewAdminAutocompleteField.Option] = [],
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
            self.identityOptions = identityOptions
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
                NewAdminAutocompleteField(
                    state: .init(
                        name: state.identityId.key,
                        label: state.identityId.label,
                        placeholder: "Select a user identity",
                        options: state.identityOptions,
                        error: state.identityId.error,
                        isRequired: true
                    )
                )
            )

            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.email.key,
                        label: state.email.label,
                        value: state.email.value,
                        error: state.email.error,
                        type: .email,
                        isRequired: true
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
