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

struct AuthMagicLinkForm: Leaf {

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
        var emailOptions: [AdminAutocompleteField.OptionState]
        var isPersistent: CheckboxState
        var error: String?
        var success: String?

        init(
            credentialId: FieldState,
            emailOptions: [AdminAutocompleteField.OptionState] = [],
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
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func renderHTML() -> Form {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            AdminAutocompleteField(
                state: .init(
                    key: state.credentialId.key,
                    label: "Email",
                    placeholder: "Select an email",
                    options: state.emailOptions,
                    error: state.credentialId.error,
                    selectionMode: .single,
                    isEnabled: true
                )
            ).renderHTML()

            CheckboxField(
                state: .init(
                    key: state.isPersistent.key,
                    label: state.isPersistent.label,
                    value: state.isPersistent.value,
                    error: state.isPersistent.error,
                    labelPosition: .before,

                )
            ).renderHTML()

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        ).renderHTML()
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
