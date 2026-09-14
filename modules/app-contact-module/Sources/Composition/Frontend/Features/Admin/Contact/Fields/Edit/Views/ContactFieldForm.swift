import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct ContactFieldForm: Component {
    let field: AdminContactFieldRow
    let action: String
    let submitLabel: String

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action) {
            context.render(
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
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "key",
                        label: "Key",
                        value: field.key,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "label",
                        label: "Label",
                        value: field.label,
                        isRequired: true
                    )
                )
            )
            context.render(
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
            context.render(
                NewAdminFormFieldCheckbox(
                    state: .init(
                        name: "isRequired",
                        label: "Required",
                        isChecked: field.isRequired
                    )
                )
            )
            Div { context.render(NewAdminSubmitButton(submitLabel)) }
                .class("new-admin-form__actions")
        }
        return context.render(form)
    }
}
