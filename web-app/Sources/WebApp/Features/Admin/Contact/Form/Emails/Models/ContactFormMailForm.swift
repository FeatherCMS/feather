import HTML
import SGML
import WebStandards

struct ContactFormMailForm: Component, FlowContent {
    let mail: AdminContactFormEmail
    let action: String
    let submitLabel: String
    let error: String?

    func content() -> some BasicTag {
        Form {
            if let error { P(error).class("error") }
            Section {
                Label {
                    AdminFieldLabel(label: "Mail from", required: true)
                    Input().type(.text).name("mailFrom").value(mail.mailFrom)
                        .required()
                }
            }
            Section {
                Label {
                    AdminFieldLabel(label: "Mail to address", required: true)
                    Input().type(.text).name("mailTo").value(mail.mailTo)
                        .required()
                }
            }
            Section {
                Label {
                    AdminFieldLabel(label: "Subject", required: true)
                    Input().type(.text).name("subject").value(mail.subject)
                        .required()
                }
            }
            Section {
                Label {
                    AdminFieldLabel(
                        label: "Additional headers",
                        required: false
                    )
                    Textarea(mail.additionalHeaders).class("text-input")
                        .name("additionalHeaders").rows(4)
                }
            }
            Section {
                Label {
                    AdminFieldLabel(label: "Message body", required: true)
                    Textarea(mail.messageBody).class("text-input")
                        .name("messageBody").rows(12).required()
                }
            }
            Div { Button(submitLabel).type(.submit) }.class("button-row")
        }
        .encType(.urlencoded).method(.post).action(action).class("cms-form")
    }
}
