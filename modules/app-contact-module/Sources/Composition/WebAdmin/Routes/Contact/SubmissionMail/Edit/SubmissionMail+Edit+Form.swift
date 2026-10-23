import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Edit {
    struct Form: Component {
        let formId: String
        let mail: AdminContactFormEmail
        let availableFields: [AdminContactFormFieldOption]
        let breadcrumb: [AdminBreadcrumb.Link]
        let error: String?
        let routes: Contact.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit contact form email",
                            description:
                                "Update the notification email for this contact form."
                        )
                    )
                )
                context.build(
                    AdminContactFormTabs(formId: formId, active: .emails)
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Notification email",
                            description:
                                "Configure the notification message for this contact form."
                        )
                    ) {
                        replacementVariables
                        context.build(
                            SubmissionMailForm(
                                mail: mail,
                                action: routes.formEmailEditPath(
                                    formKey: formId,
                                    mailId: mail.id
                                ),
                                submitLabel: "Save",
                                error: error
                            )
                        )
                    }
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
}
