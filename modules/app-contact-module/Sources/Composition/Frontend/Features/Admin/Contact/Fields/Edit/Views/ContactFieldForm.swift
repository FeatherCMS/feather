import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct ContactFieldForm: Component {
    let field: AdminContactFieldRow
    let action: String
    let submitLabel: String
    let error: String?
    let fieldErrors: [String: String]

    func html(context: inout BuilderContext) -> Form {
        let form = AdminForm(action: action) {
            if let error {
                P(error).class("admin-form__error")
            }
            context.build(
                AdminFormFieldSelect(
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
                            .init(label: "Hidden", value: "hidden"),
                        ],
                        isRequired: true
                    )
                )
            )
            context.build(
                AdminFormFieldInput(
                    state: .init(
                        name: "key",
                        label: "Key",
                        value: field.key,
                        isRequired: true
                    )
                )
            )
            context.build(
                AdminFormFieldInput(
                    state: .init(
                        name: "label",
                        label: "Label",
                        value: field.label,
                        isRequired: true
                    )
                )
            )
            context.build(
                AdminFormFieldMultiInput(
                    state: .init(
                        name: "allowedValues[]",
                        label: "Allowed values",
                        values: field.allowedValues,
                        error: fieldErrors["allowedValues"],
                        help:
                            "Required for select and radio fields. Type a value and press Enter or comma to add it."
                    )
                )
            )
            context.build(
                AdminFormFieldCheckbox(
                    state: .init(
                        name: "isRequired",
                        label: "Field validation",
                        checkboxLabel: "Require this field",
                        isChecked: field.isRequired
                    )
                )
            )
            Div { context.build(AdminSubmitButton(submitLabel)) }
                .class("admin-form__actions")
        }
        return context.build(form)
    }
}
