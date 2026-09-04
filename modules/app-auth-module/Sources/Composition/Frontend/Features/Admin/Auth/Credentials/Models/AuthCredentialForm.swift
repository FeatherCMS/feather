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

struct AuthCredentialForm: Leaf {
    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var identity: FieldState
        var identityOptions: [AdminAutocompleteField.OptionState]
        var email: FieldState
        var password: FieldState
        var passwordRequired: Bool
        var error: String?
        var success: String?

        mutating func apply(errors: [String: String]) {
            identity.error = errors[identity.key]
            email.error = errors[email.key]
            password.error = errors[password.key]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var removeHref: String?

    func renderHTML() -> Form {
        Form {
            if let success = state.success { P(success).class("success") }
            if let error = state.error { P(error).class("error") }
            Input()
                .type(.hidden)
                .name("userId")
                .value(state.identity.value)
            AdminAutocompleteField(
                state: .init(
                    key: state.email.key,
                    label: "Auth email",
                    placeholder: "Select an email",
                    options: state.identityOptions,
                    error: state.email.error,
                    selectionMode: .single,
                    isEnabled: true
                )
            ).renderHTML()
            Section {
                Label {
                    AdminFieldLabel(
                        label: state.password.label,
                        required: state.passwordRequired
                    ).renderHTML()
                    Input()
                        .type(.password)
                        .id(state.password.key)
                        .name(state.password.key)
                        .value(state.password.value)
                }
                if let error = state.password.error {
                    Span(error).class("field-error")
                }
            }
            .if(state.password.error != nil) { $0.class("has-error") }
            Section {
                Div {
                    Button(submitLabel).type(.submit)
                    if let removeHref {
                        AdminNavigationButton(
                            "Remove credential",
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
