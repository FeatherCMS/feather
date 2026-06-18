import CSS
import HTML
import SGML
import WebStandards

struct WebMenuForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: Object {
        var key: FieldState
        var name: FieldState
        var notes: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            key.error = errors[key.key]
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

            field(state.key)
            field(state.name)
            textarea(state.notes)

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

    private func field(
        _ field: FieldState
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(
                    label: field.label,
                    required: field.key == "key" || field.key == "name"
                )
                Input()
                    .type(.text)
                    .id(field.key)
                    .name(field.key)
                    .value(field.value)
            }
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
    }

    private func textarea(
        _ field: FieldState
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: field.label, required: false)
                Textarea(field.value ?? "")
                    .id(field.key)
                    .name(field.key)
                    .rows(8)
            }
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
    }
}
