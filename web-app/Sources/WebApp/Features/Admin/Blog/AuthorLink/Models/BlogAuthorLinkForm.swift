import CSS
import HTML
import SGML
import WebStandards

struct BlogAuthorLinkForm: Component, FlowContent {

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
        var label: FieldState
        var url: FieldState
        var priority: FieldState
        var isBlank: CheckboxState
        var permission: FieldState
        var notes: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            label.error = errors[label.key]
            url.error = errors[url.key]
            priority.error = errors[priority.key]
            isBlank.error = errors[isBlank.key]
            permission.error = errors[permission.key]
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

            field(state.label)
            field(state.url)
            field(state.priority)
            checkbox(state.isBlank)
            field(state.permission)
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
                    required:
                        field.key == "label"
                        || field.key == "url"
                        || field.key == "priority"
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
                    .rows(6)
            }
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
    }

    private func checkbox(
        _ field: CheckboxState
    ) -> some BasicTag {
        Section {
            CheckboxField(
                state: .init(
                    key: field.key,
                    label: field.label,
                    value: field.value,
                    error: field.error
                )
            )
        }
    }
}
