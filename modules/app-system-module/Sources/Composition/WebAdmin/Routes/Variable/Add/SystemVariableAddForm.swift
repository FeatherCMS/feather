import FeatherAdmin
import HTML
import SGML
import SystemModule
import WebBuilders
import WebComponents

struct SystemVariableAddForm: Component {
    struct State: Sendable {
        var key: AdminFormFieldInput.State
        var name: AdminFormFieldInput.State
        var value: AdminFormFieldTextArea.State
        var notes: AdminFormFieldTextArea.State
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

    func html(context: inout BuilderContext) -> Form {
        let form = AdminForm(action: action, nonceToken: nonceToken) {
            if let error = state.error {
                P(error).class("admin-form__error")
            }
            context.build(AdminFormFieldInput(state: state.key))
            context.build(AdminFormFieldTextArea(state: state.value))
            context.build(AdminFormFieldInput(state: state.name))
            context.build(AdminFormFieldTextArea(state: state.notes))
            Div {
                context.build(
                    AdminSubmitButton("Add variable", style: .primary)
                )
            }
            .class("admin-form__actions")
        }
        return context.build(form)
    }
}
