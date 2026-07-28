import HTML
import SGML
import WebStandards

struct ContactFormMailAdd: Component {
    let formId: String
    let mail: AdminContactFormEmail
    let availableFields: [AdminContactFormFieldOption]
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func content() -> some BasicTag {
        Section {
            AdminContactFormTabs(formId: formId, active: .emails)
            AdminBreadcrumb(state: breadcrumb)
            H1("Add contact form email")
            replacementVariables
            ContactFormMailForm(
                mail: mail,
                action: "/admin/contact/forms/\(formId)/emails/add/",
                submitLabel: "Add email",
                error: error
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
