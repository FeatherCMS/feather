import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormFieldAddView: Leaf {
    struct State {
        let formId: String
        let key: String
        let type: String
        let label: String
        let allowedValues: String
        let isRequired: Bool
        let position: String
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func renderHTML() -> some BasicTag {
        let basePath = "/admin/contact/forms/\(state.formId)/fields"
        return Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Add contact form field")
            if let error = state.error { P(error).class("error") }
            Form {
                Label {
                    AdminFieldLabel(label: "Type", required: true).renderHTML()
                    Select {
                        if state.type == "text" {
                            Option("Text").value("text").selected()
                        }
                        else {
                            Option("Text").value("text")
                        }
                        if state.type == "textarea" {
                            Option("Textarea").value("textarea").selected()
                        }
                        else {
                            Option("Textarea").value("textarea")
                        }
                        if state.type == "select" {
                            Option("Select").value("select").selected()
                        }
                        else {
                            Option("Select").value("select")
                        }
                        if state.type == "radio" {
                            Option("Radio").value("radio").selected()
                        }
                        else {
                            Option("Radio").value("radio")
                        }
                        if state.type == "toggle" {
                            Option("Toggle").value("toggle").selected()
                        }
                        else {
                            Option("Toggle").value("toggle")
                        }
                    }
                    .name("type").class("text-input")
                }
                Label {
                    AdminFieldLabel(label: "Key", required: true).renderHTML()
                    Input().type(.text).class("text-input").name("key")
                        .value(state.key).required()
                }
                Label {
                    AdminFieldLabel(label: "Label", required: true).renderHTML()
                    Input().type(.text).class("text-input").name("label")
                        .value(state.label).required()
                }
                Label {
                    AdminFieldLabel(label: "Allowed values", required: false).renderHTML()
                    Textarea(state.allowedValues).class("text-input")
                        .name("allowedValues").placeholder("One value per line")
                }
                Label {
                    Input().type(.checkbox).name("isRequired")
                        .if(state.isRequired) { $0.checked() }
                    Span(" Required")
                }
                Div { Button("Add").type(.submit) }.class("button-row")
            }
            .method(.post)
            .action("\(basePath)/add/")
            .class("cms-form")
        }
        .class("cms-section")
    }
}
