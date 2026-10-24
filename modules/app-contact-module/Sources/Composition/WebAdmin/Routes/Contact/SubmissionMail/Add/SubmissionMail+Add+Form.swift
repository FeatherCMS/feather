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

extension SubmissionMail.Add {
    struct Form: Component {
        let formId: String
        let mail: ContactModule.Form.Email
        let availableFields: [ContactModule.FormField.Option]
        let breadcrumb: [AdminBreadcrumb.Link]
        let error: String?
        let routes: Contact.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add contact form email",
                            description:
                                "Define the notification email sent by this contact form."
                        )
                    )
                )
                context.build(
                    ContactModule.Form.TabBar(formId: formId, active: .emails)
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
                            SubmissionMail.Form.Component(
                                mail: mail,
                                action: routes.formEmailAddPath(formId),
                                submitLabel: "Add email",
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
