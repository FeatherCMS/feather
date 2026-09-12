import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemVariableAddForm: Component {
    struct State: Sendable {
        var key: NewAdminFormFieldInput.State
        var name: NewAdminFormFieldInput.State
        var value: NewAdminFormFieldTextArea.State
        var notes: NewAdminFormFieldTextArea.State
        var error: String?
        var success: String?

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

        static func from(input: SystemVariableAddFormInput) -> Self {
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
    let nonceToken: String?

    init(
        state: State,
        action: String,
        nonceToken: String? = nil
    ) {
        self.state = state
        self.action = action
        self.nonceToken = nonceToken
    }

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let success = state.success { P(success).class("success") }
            if let error = state.error { P(error).class("error") }
            context.render(NewAdminFormFieldInput(state: state.key))
            context.render(NewAdminFormFieldInput(state: state.name))
            context.render(NewAdminFormFieldTextArea(state: state.value))
            context.render(NewAdminFormFieldTextArea(state: state.notes))
            Div {
                context.render(
                    NewAdminSubmitButton("Add variable", style: .primary)
                )
            }
            .class("new-admin-form__actions")
        }
        context.register(form)
        return form.html(context: &context)
    }
}
