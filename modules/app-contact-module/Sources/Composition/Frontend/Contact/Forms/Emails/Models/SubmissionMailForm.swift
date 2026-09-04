import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct SubmissionMailForm: Leaf {
    let mail: AdminContactFormEmail
    let action: String
    let submitLabel: String
    let error: String?

    func renderHTML() -> Form {
        Form {
            if let error { P(error).class("error") }
            Section {
                Label {
                    AdminFieldLabel(label: "Mail from", required: true).renderHTML()
                    Input().type(.text).name("mailFrom").value(mail.mailFrom)
                        .required()
                }
            }
            Section {
                Label {
                    AdminFieldLabel(label: "Mail to address", required: true).renderHTML()
                    Input().type(.text).name("mailTo").value(mail.mailTo)
                        .required()
                }
            }
            Section {
                Label {
                    AdminFieldLabel(label: "Subject", required: true).renderHTML()
                    Input().type(.text).name("subject").value(mail.subject)
                        .required()
                }
            }
            Section {
                Label {
                    AdminFieldLabel(
                        label: "Additional headers",
                        required: false
                    ).renderHTML()
                    Textarea(mail.additionalHeaders).class("text-input")
                        .name("additionalHeaders").rows(4)
                }
            }
            Section {
                Label {
                    AdminFieldLabel(label: "Message body", required: true).renderHTML()
                    Textarea(mail.messageBody).class("text-input")
                        .name("messageBody").rows(12).required()
                }
            }
            Div { Button(submitLabel).type(.submit) }.class("button-row")
        }
        .encType(.urlencoded).method(.post).action(action).class("cms-form")
    }
}
