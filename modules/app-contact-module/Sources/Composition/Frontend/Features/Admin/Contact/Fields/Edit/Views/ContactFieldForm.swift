import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct ContactFieldForm: Component {
    let field: AdminContactFieldRow
    let action: String
    let submitLabel: String

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action) {
            context.build(
                NewAdminFormFieldSelect(
                    state: .init(
                        name: "type",
                        label: "Type",
                        value: field.type,
                        options: [
                            .init(label: "Text", value: "text"),
                            .init(label: "Textarea", value: "textarea"),
                            .init(label: "Select", value: "select"),
                            .init(label: "Radio", value: "radio"),
                            .init(label: "Toggle", value: "toggle"),
                        ],
                        isRequired: true
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "key",
                        label: "Key",
                        value: field.key,
                        isRequired: true
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "label",
                        label: "Label",
                        value: field.label,
                        isRequired: true
                    )
                )
            )
            context.build(
                NewAdminFormFieldTextArea(
                    state: .init(
                        name: "allowedValues",
                        label: "Allowed values",
                        value: field.allowedValues,
                        help: "One value per line.",
                        style: .small
                    )
                )
            )
            context.build(
                NewAdminFormFieldCheckbox(
                    state: .init(
                        name: "isRequired",
                        label: "Field validation",
                        checkboxLabel: "Require this field",
                        isChecked: field.isRequired
                    )
                )
            )
            Div { context.build(NewAdminSubmitButton(submitLabel)) }
                .class("new-admin-form__actions")
        }
        return context.build(form)
    }
}
