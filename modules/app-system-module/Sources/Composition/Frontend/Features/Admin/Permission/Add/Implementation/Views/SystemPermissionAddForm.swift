import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemPermissionAddForm: Component {
    struct State: Sendable {
        var key: NewAdminFormFieldInput.State
        var name: NewAdminFormFieldInput.State
        var notes: NewAdminFormFieldTextArea.State
        var error: String?

        mutating func apply(errors: [String: String]) {
            key.error = errors[key.name]
            name.error = errors[name.name]
            notes.error = errors[notes.name]
        }

        static func empty() -> Self {
            .init(
                key: .init(name: "key", label: "Key", isRequired: true),
                name: .init(name: "name", label: "Name"),
                notes: .init(name: "notes", label: "Notes", style: .small),
                error: nil
            )
        }
    }

    let state: State
    let action: String
    let nonceToken: String?

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let error = state.error { P(error).class("new-admin-form__error") }
            context.render(NewAdminFormFieldInput(state: state.key))
            context.render(NewAdminFormFieldInput(state: state.name))
            context.render(NewAdminFormFieldTextArea(state: state.notes))
            Div {
                context.render(NewAdminSubmitButton("Add permission", style: .primary))
            }
            .class("new-admin-form__actions")
        }
        context.register(form)
        return form.html(context: &context)
    }
}
