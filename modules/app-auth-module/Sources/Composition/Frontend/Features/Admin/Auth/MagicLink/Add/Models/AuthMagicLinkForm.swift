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
import WebStandards

struct AuthMagicLinkForm: Component, FlowContent {

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
        var isPersistent: CheckboxState
        var error: String?
        var success: String?

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

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            FormInputField(
                name: state.credentialId.key,
                label: state.credentialId.label,
                value: state.credentialId.value,
                error: state.credentialId.error,
                isRequired: true
            )

            CheckboxField(
                state: .init(
                    key: state.isPersistent.key,
                    label: state.isPersistent.label,
                    value: state.isPersistent.value,
                    error: state.isPersistent.error,
                    labelPosition: .before,

                )
            )

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        )
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
