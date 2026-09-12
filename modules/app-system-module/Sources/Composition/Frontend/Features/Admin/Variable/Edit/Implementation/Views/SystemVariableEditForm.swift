import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemVariableEditForm: Component {
    struct State: Sendable {
        var id: NewAdminFormFieldInput.State
        var name: NewAdminFormFieldInput.State
        var value: NewAdminFormFieldTextArea.State
        var notes: NewAdminFormFieldTextArea.State
        var error: String?
        var success: String?

        mutating func apply(errors: [String: String]) {
            id.error = errors[id.name]
            name.error = errors[name.name]
            value.error = errors[value.name]
            notes.error = errors[notes.name]
        }

        mutating func apply(error message: String) { error = message }

        static func empty() -> Self {
            .init(
                id: .init(name: "id", label: "ID", value: "", isRequired: true),
                name: .init(
                    name: "name",
                    label: "Name",
                    value: "",
                    isRequired: true
                ),
                value: .init(
                    name: "value",
                    label: "Value",
                    value: "",
                    style: .small,
                    isRequired: true
                ),
                notes: .init(
                    name: "notes",
                    label: "Notes",
                    value: "",
                    style: .small
                ),
                error: nil,
                success: nil
            )
        }

        static func from(variable: SystemVariableDetailsModel) -> Self {
            .init(
                id: .init(
                    name: "id",
                    label: "ID",
                    value: variable.id,
                    isRequired: true
                ),
                name: .init(
                    name: "name",
                    label: "Name",
                    value: variable.name ?? "",
                    isRequired: true
                ),
                value: .init(
                    name: "value",
                    label: "Value",
                    value: variable.value,
                    style: .small,
                    isRequired: true
                ),
                notes: .init(
                    name: "notes",
                    label: "Notes",
                    value: variable.notes ?? "",
                    style: .small
                ),
                error: nil,
                success: nil
            )
        }

        static func from(input: SystemVariableEditFormInput) -> Self {
            .init(
                id: .init(
                    name: "id",
                    label: "ID",
                    value: input.normalizedID,
                    isRequired: true
                ),
                name: .init(
                    name: "name",
                    label: "Name",
                    value: input.normalizedName,
                    isRequired: true
                ),
                value: .init(
                    name: "value",
                    label: "Value",
                    value: input.normalizedValue,
                    style: .small,
                    isRequired: true
                ),
                notes: .init(
                    name: "notes",
                    label: "Notes",
                    value: input.normalizedNotes,
                    style: .small
                ),
                error: nil,
                success: nil
            )
        }
    }

    let state: State
    let action: String
    let submitLabel: String
    let removeHref: String?
    let nonceToken: String?

    init(
        state: State,
        action: String,
        submitLabel: String,
        removeHref: String?,
        nonceToken: String? = nil
    ) {
        self.state = state
        self.action = action
        self.submitLabel = submitLabel
        self.removeHref = removeHref
        self.nonceToken = nonceToken
    }

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let success = state.success { P(success).class("success") }
            if let error = state.error { P(error).class("error") }
            context.render(NewAdminFormFieldInput(state: state.id))
            context.render(NewAdminFormFieldInput(state: state.name))
            context.render(NewAdminFormFieldTextArea(state: state.value))
            context.render(NewAdminFormFieldTextArea(state: state.notes))
            Div {
                context.render(
                    NewAdminSubmitButton(submitLabel, style: .primary)
                )
                if let removeHref {
                    context.render(
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
        context.register(form)
        return form.html(context: &context)
    }
}
