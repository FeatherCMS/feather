import CSS
import HTML
import SGML
import WebStandards

struct AuthProfileForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: Object {
        var email: FieldState
        var password: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            email.error = errors[email.key]
            password.error = errors[password.key]
        }
    }

    var state: State
    var action: String = "/admin/auth/profile/edit/"
    var submitLabel: String = "Edit profile"

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            FormInputField(
                name: state.email.key,
                label: state.email.label,
                value: state.email.value,
                error: state.email.error,
                isRequired: true,
                inputClass: "text-input"
            )

            FormInputField(
                name: state.password.key,
                label: state.password.label,
                value: state.password.value,
                error: state.password.error,
                type: .password,
                inputClass: "text-input"
            )

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
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
