import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFieldForm: Component {
    let field: AdminContactFieldRow
    let action: String
    let submitLabel: String

    func html(context: inout RenderContext) -> Form {
        Form {
            Label {
                context.render(AdminFieldLabel(label: "Type", required: true))
                Select {
                    for type in [
                        "text", "textarea", "select", "radio", "toggle",
                    ] {
                        Option(type.capitalized).value(type)
                            .if(field.type == type) { $0.selected() }
                    }
                }
                .name("type").class("text-input")
            }
            Label {
                context.render(AdminFieldLabel(label: "Key", required: true))
                Input().type(.text).class("text-input").name("key")
                    .value(field.key).required()
            }
            Label {
                context.render(AdminFieldLabel(label: "Label", required: true))
                Input().type(.text).class("text-input").name("label")
                    .value(field.label).required()
            }
            Label {
                context.render(AdminFieldLabel(label: "Allowed values", required: false))
                Textarea(field.allowedValues).class("text-input")
                    .name("allowedValues")
            }
            Label {
                Input().type(.checkbox).name("isRequired")
                    .if(field.isRequired) { $0.checked() }
                Span(" Required")
            }
            Div { Button(submitLabel).type(.submit) }.class("button-row")
        }
        .method(.post).action(action).class("cms-form")
    }
}
