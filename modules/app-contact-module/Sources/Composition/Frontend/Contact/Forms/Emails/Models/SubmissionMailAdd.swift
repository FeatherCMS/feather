import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct SubmissionMailAdd: Leaf {
    let formId: String
    let mail: AdminContactFormEmail
    let availableFields: [AdminContactFormFieldOption]
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func html() -> some BasicTag {
        Section {
            AdminContactFormTabs(formId: formId, active: .emails).html()
            AdminBreadcrumb(state: breadcrumb).html()
            H1("Add contact form email")
            replacementVariables
            SubmissionMailForm(
                mail: mail,
                action: "/admin/contact/forms/\(formId)/emails/add/",
                submitLabel: "Add email",
                error: error
            ).html()
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
