import CSS
import HTML
import SGML
import WebStandards

struct AuthMagicLinkForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct CheckboxState: Object {
        var key: String
        var label: String
        var value: Bool
        var error: String?
    }

    struct State: Object {
        var email: FieldState
        var isPersistent: CheckboxState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
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
                name: state.email.key,
                label: state.email.label,
                value: state.email.value,
                error: state.email.error,
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
