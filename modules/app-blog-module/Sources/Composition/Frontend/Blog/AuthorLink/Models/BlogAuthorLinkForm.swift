import FeatherAdmin
import HTML
import WebBuilders
import WebComponents

struct BlogAuthorLinkForm: Component {
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
        var label: FieldState
        var url: FieldState
        var priority: FieldState
        var isBlank: CheckboxState
        var permission: FieldState
        var notes: FieldState
        var error: String?

        mutating func apply(errors: [String: String]) {
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
    var removeHref: String?
    var removeLabel: String = "Remove"

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.label.key,
                        label: state.label.label,
                        value: state.label.value,
                        error: state.label.error,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.url.key,
                        label: state.url.label,
                        value: state.url.value,
                        error: state.url.error,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.priority.key,
                        label: state.priority.label,
                        value: state.priority.value,
                        error: state.priority.error,
                        type: .number,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldCheckbox(
                    state: .init(
                        name: state.isBlank.key,
                        label: "Link target",
                        checkboxLabel: "Open link in a new tab",
                        isChecked: state.isBlank.value,
                        error: state.isBlank.error
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.permission.key,
                        label: state.permission.label,
                        value: state.permission.value,
                        error: state.permission.error
                    )
                )
            )
            context.render(
                NewAdminFormFieldTextArea(
                    state: .init(
                        name: state.notes.key,
                        label: state.notes.label,
                        value: state.notes.value,
                        error: state.notes.error,
                        style: .medium
                    )
                )
            )
            Div {
                context.render(
                    NewAdminSubmitButton(submitLabel, style: .primary)
                )
                if let removeHref {
                    context.render(
                        NewAdminButton(
                            removeLabel,
                            href: removeHref,
                            style: .destructive
                        )
                    )
                }
            }
            .class("new-admin-form__actions")
        }
        return context.render(form)
    }
}
