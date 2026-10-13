import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemVariableEditForm: Component {
    struct State: Sendable {
        var key: NewAdminFormFieldInput.State
        var name: NewAdminFormFieldInput.State
        var value: NewAdminFormFieldTextArea.State
        var notes: NewAdminFormFieldTextArea.State
        var error: String?

        mutating func apply(errors: [String: String]) {
            key.error = errors[key.name]
            name.error = errors[name.name]
            value.error = errors[value.name]
            notes.error = errors[notes.name]
        }

        mutating func apply(error message: String) { error = message }

        static func empty() -> Self {
            .init(
                key: .init(
                    name: "key",
                    label: "Key",
                    value: "",
                    isRequired: true
                ),
                name: .init(
                    name: "name",
                    label: "Name",
                    value: "",
                    isRequired: false
                ),
                value: .init(
                    name: "value",
                    label: "Value",
                    value: "",
                    style: .small
                ),
                notes: .init(
                    name: "notes",
                    label: "Notes",
                    value: "",
                    style: .small
                ),
                error: nil
            )
        }

        static func from(variable: SystemVariableEditModel) -> Self {
            .init(
                key: .init(
                    name: "key",
                    label: "Key",
                    value: variable.key,
                    isRequired: true
                ),
                name: .init(
                    name: "name",
                    label: "Name",
                    value: variable.name ?? "",
                    isRequired: false
                ),
                value: .init(
                    name: "value",
                    label: "Value",
                    value: variable.value,
                    style: .small
                ),
                notes: .init(
                    name: "notes",
                    label: "Notes",
                    value: variable.notes ?? "",
                    style: .small
                ),
                error: nil
            )
        }

        static func from(input: SystemVariableEditFormInput) -> Self {
            .init(
                key: .init(
                    name: "key",
                    label: "Key",
                    value: input.normalizedKey,
                    isRequired: true
                ),
                name: .init(
                    name: "name",
                    label: "Name",
                    value: input.normalizedName,
                    isRequired: false
                ),
                value: .init(
                    name: "value",
                    label: "Value",
                    value: input.normalizedValue,
                    style: .small
                ),
                notes: .init(
                    name: "notes",
                    label: "Notes",
                    value: input.normalizedNotes,
                    style: .small
                ),
                error: nil
            )
        }
    }

    let state: State
    let action: String
    let viewHref: String
    let removeHref: String?
    let nonceToken: String?

    init(
        state: State,
        action: String,
        viewHref: String,
        removeHref: String?,
        nonceToken: String? = nil
    ) {
        self.state = state
        self.action = action
        self.viewHref = viewHref
        self.removeHref = removeHref
        self.nonceToken = nonceToken
    }

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(NewAdminFormFieldInput(state: state.key))
            context.build(NewAdminFormFieldTextArea(state: state.value))
            context.build(NewAdminFormFieldInput(state: state.name))
            context.build(NewAdminFormFieldTextArea(state: state.notes))
            Div {
                context.build(
                    NewAdminSubmitButton("Save changes", style: .primary)
                )
                context.build(
                    NewAdminButton("View", href: viewHref, style: .secondary)
                )
                if let removeHref {
                    context.build(
                        NewAdminButton(
                            "Remove",
                            href: removeHref,
                            style: .destructive
                        )
                    )
                }
            }
            .class("new-admin-form__actions")
        }
        return context.build(form)
    }
}
