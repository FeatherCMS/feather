import HTML
import SGML
import WebStandards

struct ContactFormItemForm: Component, FlowContent {
    let item: AdminManageContactFormItemRow
    let action: String
    let submitLabel: String

    func content() -> some BasicTag {
        Form {
            Label { AdminFieldLabel(label: "Key", required: true); Input().type(.text).class("text-input").name("key").value(item.key).required() }
            Label {
                AdminFieldLabel(label: "Type", required: true)
                Select { for type in ["text", "textarea", "select", "radio", "toggle"] { Option(type.capitalized).value(type).if(item.type == type) { $0.selected() } } }.name("type").class("text-input")
            }
            Label { AdminFieldLabel(label: "Label", required: true); Input().type(.text).class("text-input").name("label").value(item.label).required() }
            Label { AdminFieldLabel(label: "Allowed values", required: false); Textarea(item.allowedValues).class("text-input").name("allowedValues") }
            Label { Input().type(.checkbox).name("isRequired").if(item.isRequired) { $0.checked() }; Span(" Required") }
            Label { AdminFieldLabel(label: "Position", required: false); Input().type(.number).class("text-input").name("position").value(item.position) }
            Div { Button(submitLabel).type(.submit) }.class("button-row")
        }.method(.post).action(action).class("cms-form")
    }
}
