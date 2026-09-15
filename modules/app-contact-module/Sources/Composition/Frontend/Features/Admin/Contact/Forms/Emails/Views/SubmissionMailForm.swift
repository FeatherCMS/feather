import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SubmissionMailForm: Component {
    let mail: AdminContactFormEmail
    let action: String
    let submitLabel: String
    let error: String?

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let error { P(error).class("new-admin-form__error") }
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "mailFrom",
                        label: "Mail from",
                        value: mail.mailFrom,
                        isRequired: true
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "mailTo",
                        label: "Mail to address",
                        value: mail.mailTo,
                        isRequired: true
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "subject",
                        label: "Subject",
                        value: mail.subject,
                        isRequired: true
                    )
                )
            )
            context.build(
                NewAdminFormFieldTextArea(
                    state: .init(
                        name: "additionalHeaders",
                        label: "Additional headers",
                        value: mail.additionalHeaders,
                        style: .small
                    )
                )
            )
            context.build(
                NewAdminFormFieldTextArea(
                    state: .init(
                        name: "messageBody",
                        label: "Message body",
                        value: mail.messageBody,
                        style: .large,
                        isRequired: true
                    )
                )
            )
            Div { context.build(NewAdminSubmitButton(submitLabel)) }
                .class("new-admin-form__actions")
        }
        return context.build(form)
    }
}
