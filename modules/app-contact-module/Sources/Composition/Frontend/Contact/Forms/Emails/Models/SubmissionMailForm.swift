import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct SubmissionMailForm: Component {
    let mail: AdminContactFormEmail
    let action: String
    let submitLabel: String
    let error: String?

    func html(context: inout RenderContext) -> Form {
        Form {
            if let error { P(error).class("error") }
            Section {
                Label {
                    context.render(AdminFieldLabel(label: "Mail from", required: true))
                    Input().type(.text).name("mailFrom").value(mail.mailFrom)
                        .required()
                }
            }
            Section {
                Label {
                    context.render(AdminFieldLabel(label: "Mail to address", required: true))
                    Input().type(.text).name("mailTo").value(mail.mailTo)
                        .required()
                }
            }
            Section {
                Label {
                    context.render(AdminFieldLabel(label: "Subject", required: true))
                    Input().type(.text).name("subject").value(mail.subject)
                        .required()
                }
            }
            Section {
                Label {
                    context.render(AdminFieldLabel(
                        label: "Additional headers",
                        required: false
                    ))
                    Textarea(mail.additionalHeaders).class("text-input")
                        .name("additionalHeaders").rows(4)
                }
            }
            Section {
                Label {
                    context.render(AdminFieldLabel(label: "Message body", required: true))
                    Textarea(mail.messageBody).class("text-input")
                        .name("messageBody").rows(12).required()
                }
            }
            Div { Button(submitLabel).type(.submit) }.class("button-row")
        }
        .encType(.urlencoded).method(.post).action(action).class("cms-form")
    }
}
