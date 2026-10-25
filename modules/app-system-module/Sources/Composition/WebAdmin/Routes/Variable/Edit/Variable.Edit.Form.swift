import FeatherWebAdmin
import HTML
import SGML
import SystemModule
import WebBuilders
import WebComponents

extension Variable.Edit {
    struct Form: Component {
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

            static func from(variable: Model) -> Self {
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

            static func from(input: Form.Input) -> Self {
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

        func html(context: inout BuilderContext) -> HTML.Form {
            let form = AdminForm(action: action, nonceToken: nonceToken) {
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                context.build(
                    AdminFormFieldInput(state: state.key)
                        .setAsRemoveConfirmationLabel(
                            state.name.value?.isEmpty != false
                        )
                )
                context.build(AdminFormFieldTextArea(state: state.value))
                context.build(
                    AdminFormFieldInput(state: state.name)
                        .setAsRemoveConfirmationLabel(
                            state.name.value?.isEmpty == false
                        )
                )
                context.build(AdminFormFieldTextArea(state: state.notes))
                Div {
                    context.build(
                        AdminSubmitButton("Save changes", style: .primary)
                    )
                    context.build(
                        AdminButton("View", href: viewHref, style: .secondary)
                    )
                }
                .class("admin-form__actions")
            }
            return context.build(form)
        }
    }
}
