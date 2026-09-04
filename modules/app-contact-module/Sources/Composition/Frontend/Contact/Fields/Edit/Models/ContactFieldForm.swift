import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFieldForm: Leaf {
    let field: AdminContactFieldRow
    let action: String
    let submitLabel: String

    func html() -> Form {
        Form {
            Label {
                AdminFieldLabel(label: "Type", required: true).html()
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
                AdminFieldLabel(label: "Key", required: true).html()
                Input().type(.text).class("text-input").name("key")
                    .value(field.key).required()
            }
            Label {
                AdminFieldLabel(label: "Label", required: true).html()
                Input().type(.text).class("text-input").name("label")
                    .value(field.label).required()
            }
            Label {
                AdminFieldLabel(label: "Allowed values", required: false).html()
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
