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

            Section {
                Label {
                    AdminFieldLabel(label: state.email.label, required: true)
                    Input()
                        .type(.text)
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
                    Input()
                        .type(.checkbox)
                        .id(state.isPersistent.key)
                        .name(state.isPersistent.key)
                        .if(state.isPersistent.value) { $0.checked() }
                    InlineText(state.isPersistent.label)
                }
                if let error = state.isPersistent.error {
                    Span(error).class("field-error")
                }
            }
            .if(state.isPersistent.error != nil) { $0.class("has-error") }

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
