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
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                AdminContactFormTabs(formId: formId, active: .emails)
            )
            context.render(AdminBreadcrumb(state: breadcrumb))
            H1("Edit contact form email")
            replacementVariables
            context.render(
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
