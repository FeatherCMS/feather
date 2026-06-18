import CSS
import HTML
import SGML
import WebStandards

struct UserRoleForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: Object {
        var name: FieldState
        var notes: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            name.error = errors[name.key]
            notes.error = errors[notes.key]
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
                    AdminFieldLabel(label: state.name.label, required: true)
                    Input()
                        .type(.text)
                        .id(state.name.key)
                        .name(state.name.key)
                        .value(state.name.value)
                }
                if let error = state.name.error {
                    Span(error).class("field-error")
                }
            }
            .if(state.name.error != nil) { $0.class("has-error") }

            Section {
                Label {
                    AdminFieldLabel(label: state.notes.label, required: false)
                    Input()
                        .type(.text)
                        .id(state.notes.key)
                        .name(state.notes.key)
                        .value(state.notes.value)
                }
                if let error = state.notes.error {
                    Span(error).class("field-error")
                }
            }
            .if(state.notes.error != nil) { $0.class("has-error") }

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
