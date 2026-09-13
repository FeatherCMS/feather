import FeatherAdmin
import HTML
import WebBuilders
import WebComponents

struct UserRoleForm: Component {
    struct State: Sendable {
        var id: NewAdminFormFieldInput.State?
        var name: NewAdminFormFieldInput.State
        var notes: NewAdminFormFieldTextArea.State
        var error: String?

        mutating func apply(errors: [String: String]) {
            if let id { self.id?.error = errors[id.name] }
            name.error = errors[name.name]
            notes.error = errors[notes.name]
        }

        static func addEmpty() -> Self {
            .init(
                id: .init(name: "id", label: "ID", isRequired: true),
                name: .init(name: "name", label: "Name", isRequired: true),
                notes: .init(name: "notes", label: "Notes", style: .small),
                error: nil
            )
        }

        static func edit(name: String, notes: String) -> Self {
            .init(
                id: nil,
                name: .init(name: "name", label: "Name", value: name, isRequired: true),
                notes: .init(name: "notes", label: "Notes", value: notes, style: .small),
                error: nil
            )
        }

        static func from(input: AdminAddUserRoleFormInput) -> Self {
            .init(
                id: .init(name: "id", label: "ID", value: input.normalizedID, isRequired: true),
                name: .init(name: "name", label: "Name", value: input.normalizedName, isRequired: true),
                notes: .init(name: "notes", label: "Notes", value: input.normalizedNotes, style: .small),
                error: nil
            )
        }

        static func from(input: AdminEditUserRoleFormInput) -> Self {
            .init(
                id: nil,
                name: .init(name: "name", label: "Name", value: input.normalizedName, isRequired: true),
                notes: .init(name: "notes", label: "Notes", value: input.normalizedNotes, style: .small),
                error: nil
            )
        }
    }

    let state: State
    let action: String
    let submitLabel: String
    let viewHref: String?
    let removeHref: String?
    let nonceToken: String?

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let error = state.error { P(error).class("new-admin-form__error") }
            if let id = state.id { context.render(NewAdminFormFieldInput(state: id)) }
            context.render(NewAdminFormFieldInput(state: state.name))
            context.render(NewAdminFormFieldTextArea(state: state.notes))
            Div {
                context.render(NewAdminSubmitButton(submitLabel, style: .primary))
                if let viewHref { context.render(NewAdminButton("View", href: viewHref, style: .secondary)) }
                if let removeHref { context.render(NewAdminButton("Remove", href: removeHref, style: .destructive)) }
            }
            .class("new-admin-form__actions")
        }
        context.register(form)
        return form.html(context: &context)
    }
}
