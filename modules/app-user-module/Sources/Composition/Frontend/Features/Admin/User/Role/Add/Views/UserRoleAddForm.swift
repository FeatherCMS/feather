import FeatherAdmin
import HTML
import WebBuilders
import WebComponents

struct UserRoleAddForm: Component {
    struct State: Sendable {
        var name: NewAdminFormFieldInput.State
        var notes: NewAdminFormFieldTextArea.State
        var error: String?

        mutating func apply(errors: [String: String]) {
            name.error = errors[name.name]
            notes.error = errors[notes.name]
        }

        static func addEmpty() -> Self {
            .init(
                name: .init(name: "name", label: "Name", isRequired: true),
                notes: .init(name: "notes", label: "Notes", style: .small),
                error: nil
            )
        }

        static func from(input: AdminAddUserRoleFormInput) -> Self {
            .init(
                name: .init(
                    name: "name",
                    label: "Name",
                    value: input.normalizedName,
                    isRequired: true
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
    let submitLabel: String
    let viewHref: String?
    let removeHref: String?
    let nonceToken: String?

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.render(NewAdminFormFieldInput(state: state.name))
            context.render(NewAdminFormFieldTextArea(state: state.notes))
            Div {
                context.render(
                    NewAdminSubmitButton(submitLabel, style: .primary)
                )
                if let viewHref {
                    context.render(
                        NewAdminButton(
                            "View",
                            href: viewHref,
                            style: .secondary
                        )
                    )
                }
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
