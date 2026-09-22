import FeatherAdmin
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
        let form = NewAdminForm(action: action) {
            if let error {
                P(error).class("new-admin-form__error")
            }
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
                NewAdminFormFieldMultiInput(
                    state: .init(
                        name: "allowedValues[]",
                        label: "Allowed values",
                        values: field.allowedValues
                            .split(whereSeparator: \.isNewline)
                            .map(String.init),
                        error: fieldErrors["allowedValues"],
                        help:
                            "Required for select and radio fields. Type a value and press Enter or comma to add it."
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
