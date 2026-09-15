import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct SubmissionMailEdit: Component {
    let formId: String
    let mail: AdminContactFormEmail
    let availableFields: [AdminContactFormFieldOption]
    let breadcrumb: [NewAdminBreadcrumb.Link]
    let error: String?

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminContactFormTabs(formId: formId, active: .emails)
            )
            context.build(NewAdminBreadcrumb(links: breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit contact form email",
                        description:
                            "Update the notification email for this contact form."
                    )
                )
            )
            replacementVariables
            context.build(
                SubmissionMailForm(
                    mail: mail,
                    action:
                        "/admin/contact/forms/\(formId)/emails/\(mail.id)/edit/",
                    submitLabel: "Save",
                    error: error
                )
            )
        }
        .class("cms-section")
    }

    private var replacementVariables: some FlowContent {
        P {
            Span("Available replacement variables: ")
            for (index, field) in availableFields.enumerated() {
                if index > 0 { Span(", ") }
                Span("{{\(field.key)}}")
            }
        }
        .class("contact-form-replacement-variables")
    }
}
