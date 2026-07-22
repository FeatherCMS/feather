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

            FormInputField(
                name: state.label.key,
                label: state.label.label,
                value: state.label.value,
                error: state.label.error,
                isRequired: true
            )
            FormInputField(
                name: state.url.key,
                label: state.url.label,
                value: state.url.value,
                error: state.url.error,
                isRequired: true
            )
            FormInputField(
                name: state.priority.key,
                label: state.priority.label,
                value: state.priority.value,
                error: state.priority.error,
                isRequired: true
            )
            checkbox(state.isBlank)
            FormInputField(
                name: state.permission.key,
                label: state.permission.label,
                value: state.permission.value,
                error: state.permission.error
            )
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

    private func textarea(
        _ field: FieldState
    ) -> FormTextAreaField {
        FormTextAreaField(
            name: field.key,
            label: field.label,
            value: field.value,
            error: field.error,
            rows: 6
        )
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
