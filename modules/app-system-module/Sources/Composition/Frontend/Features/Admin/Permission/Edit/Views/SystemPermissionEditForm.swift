import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemPermissionEditForm: Component {
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

        static func from(input: SystemPermissionEditFormInput) -> Self {
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
                    value: input.normalizedName ?? ""
                ),
                notes: .init(
                    name: "notes",
                    label: "Notes",
                    value: input.normalizedNotes ?? "",
                    style: .small
                ),
                error: nil
            )
        }
    }

    let state: State
    let action: String
    let viewHref: String
    let removeHref: String
    let nonceToken: String?

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(NewAdminFormFieldInput(state: state.key))
            context.build(NewAdminFormFieldInput(state: state.name))
            context.build(NewAdminFormFieldTextArea(state: state.notes))
            Div {
                context.build(
                    NewAdminSubmitButton("Save changes", style: .primary)
                )
                context.build(
                    NewAdminButton("View", href: viewHref, style: .secondary)
                )
                context.build(
                    NewAdminButton(
                        "Remove",
                        href: removeHref,
                        style: .destructive
                    )
                )
            }
            .class("new-admin-form__actions")
        }
        return context.build(form)
    }
}
