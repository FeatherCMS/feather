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

struct AuthEmailForm: Component, FlowContent {

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
        var identityId: FieldState
        var email: FieldState
        var isPrimary: CheckboxState
        var isVerified: CheckboxState
        var error: String?
        var success: String?

        init(
            identityId: FieldState,
            email: FieldState = .init(
                key: "email",
                label: "Email address",
                value: "",
                error: nil
            ),
            isPrimary: CheckboxState,
            isVerified: CheckboxState = .init(
                key: "is_verified",
                label: "Verified",
                value: false,
                error: nil
            ),
            error: String? = nil,
            success: String? = nil
        ) {
            self.identityId = identityId
            self.email = email
            self.isPrimary = isPrimary
            self.isVerified = isVerified
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

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            FormInputField(
                name: state.identityId.key,
                label: state.identityId.label,
                value: state.identityId.value,
                error: state.identityId.error,
                isRequired: true
            )

            FormInputField(
                name: state.email.key,
                label: state.email.label,
                value: state.email.value,
                error: state.email.error,
                type: .email,
                isRequired: true
            )

            CheckboxField(
                state: .init(
                    key: state.isPrimary.key,
                    label: state.isPrimary.label,
                    value: state.isPrimary.value,
                    error: state.isPrimary.error,
                    labelPosition: .before,

                )
            )

            CheckboxField(
                state: .init(
                    key: state.isVerified.key,
                    label: state.isVerified.label,
                    value: state.isVerified.value,
                    error: state.isVerified.error,
                    labelPosition: .before
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
