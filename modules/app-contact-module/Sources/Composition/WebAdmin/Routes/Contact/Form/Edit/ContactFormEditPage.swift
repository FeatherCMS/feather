import ContactModule
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormEditPage: Component {
    struct State {
        let key: String
        let isReadOnly: Bool
        let form: ContactFormForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
        let routes: Contact.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: state.isReadOnly
                            ? "Contact form" : "Edit contact form",
                        description: state.isReadOnly
                            ? "Review the contact form settings."
                            : "Update the contact form settings."
                    )
                )
            )
            context.build(
                AdminContactFormTabs(formId: state.key, active: .details)
            )
            context.build(
                AdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Form configuration",
                        description:
                            "Configure the form name, key, and submission messages."
                    )
                ) {
                    context.build(
                        ContactFormForm(
                            state: state.form,
                            action: state.routes.formEditPath(state.key),
                            submitLabel: "Save changes",
                            isReadOnly: state.isReadOnly
                        )
                    )
                }
            )
        }
        .class("cms-section")
    }
}
