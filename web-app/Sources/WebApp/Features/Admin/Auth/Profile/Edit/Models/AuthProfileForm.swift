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

            Section {
                Label {
                    AdminFieldLabel(label: state.email.label, required: true)

                    Input()
                        .type(.text)
                        .class("text-input")
                        .id(state.email.key)
                        .name(state.email.key)
                        .value(state.email.value)
                }
                if let error = state.email.error {
                    Span(error).class("field-error")
                }
            }
            .if(state.email.error != nil) { $0.class("has-error") }

            Section {
                Label {
                    AdminFieldLabel(
                        label: state.password.label,
                        required: false
                    )

                    Input()
                        .type(.password)
                        .class("text-input")
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
