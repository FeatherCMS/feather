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
import WebComponents
import WebBuilders

struct AuthEmailForm: Leaf {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var identityId: FieldState
        var identityOptions: [AdminAutocompleteField.OptionState]
        var email: FieldState
        var error: String?
        var success: String?

        init(
            identityId: FieldState,
            identityOptions: [AdminAutocompleteField.OptionState] = [],
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

    func html() -> Form {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            AdminAutocompleteField(
                state: .init(
                    key: state.identityId.key,
                    label: state.identityId.label,
                    placeholder: "Select a user identity",
                    options: state.identityOptions,
                    error: state.identityId.error,
                    selectionMode: .single,
                    isEnabled: true
                )
            ).html()

            FormInputField(
                name: state.email.key,
                label: state.email.label,
                value: state.email.value,
                error: state.email.error,
                type: .email,
                isRequired: true
            ).html()

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        ).html()
                    }
                }
                .class("button-row")
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(action)
        .class("cms-form")
    }
}
