import FeatherWebAdmin
import HTML
import UserModule
import WebBuilders
import WebComponents

extension Role.Add.Form {
    struct Component: WebComponents.Component {
        struct State: Sendable {
            var key: AdminFormFieldInput.State
            var name: AdminFormFieldInput.State
            var notes: AdminFormFieldTextArea.State
            var error: String?

            mutating func apply(errors: [String: String]) {
                key.error = errors[key.name]
                name.error = errors[name.name]
                notes.error = errors[notes.name]
            }

            static func addEmpty() -> Self {
                .init(
                    key: .init(name: "key", label: "Key", isRequired: true),
                    name: .init(name: "name", label: "Name", isRequired: true),
                    notes: .init(name: "notes", label: "Notes", style: .small),
                    error: nil
                )
            }

            static func from(input: Input) -> Self {
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

        func html(context: inout BuilderContext) -> Form {
            let form = AdminForm(action: action, nonceToken: nonceToken) {
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                context.build(AdminFormFieldInput(state: state.key))
                context.build(
                    AdminFormFieldInput(state: state.name)
                        .setAsRemoveConfirmationLabel()
                )
                context.build(AdminFormFieldTextArea(state: state.notes))
                Div {
                    context.build(
                        AdminSubmitButton(submitLabel, style: .primary)
                    )
                    if let viewHref {
                        context.build(
                            AdminButton(
                                "View",
                                href: viewHref,
                                style: .secondary
                            )
                        )
                    }
                    if let removeHref {
                        context.build(
                            AdminButton(
                                "Remove",
                                href: removeHref,
                                style: .destructive
                            )
                        )
                    }
                }
                .class("admin-form__actions")
            }
            return context.build(form)
        }
    }
}
