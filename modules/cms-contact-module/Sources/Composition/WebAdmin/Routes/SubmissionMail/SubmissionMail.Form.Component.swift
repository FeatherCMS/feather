import ContactModule
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Form {
    struct Component: WebComponents.Component {
        let mail: ContactModule.Form.Email
        let action: String
        let submitLabel: String
        let error: String?

        func html(context: inout BuilderContext) -> some FlowContent {
            let form = AdminForm(action: action) {
                if let error { P(error).class("admin-form__error") }
                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "mailFrom",
                            label: "Mail from",
                            value: mail.mailFrom,
                            isRequired: true
                        )
                    )
                )
                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "mailTo",
                            label: "Mail to address",
                            value: mail.mailTo,
                            isRequired: true
                        )
                    )
                )
                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "subject",
                            label: "Subject",
                            value: mail.subject,
                            isRequired: true
                        )
                    )
                )
                context.build(
                    AdminFormFieldMultiInput(
                        state: .init(
                            name: "additionalHeaders[]",
                            label: "Additional headers",
                            values: mail.additionalHeaders,
                            help:
                                "Type a header and press Enter to add it. Examples: Reply-To: {{email}}, CC: manager@example.com, BCC: archive@example.com.",
                            commitsOnComma: false
                        )
                    )
                )
                context.build(
                    AdminFormFieldTextArea(
                        state: .init(
                            name: "messageBody",
                            label: "Message body",
                            value: mail.messageBody,
                            style: .large,
                            isRequired: true
                        )
                    )
                )
                Div { context.build(AdminSubmitButton(submitLabel)) }
                    .class("admin-form__actions")
            }
            return context.build(form)
        }
    }
}
