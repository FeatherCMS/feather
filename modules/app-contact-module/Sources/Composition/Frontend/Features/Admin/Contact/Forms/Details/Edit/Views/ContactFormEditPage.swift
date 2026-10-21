import FeatherAdmin
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
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
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
                NewAdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Form configuration",
                        description:
                            "Configure the form name, key, and submission messages."
                    )
                ) {
                    context.build(
                        ContactFormForm(
                            state: state.form,
                            action:
                                ContactAdminRoutes.formEdit(
                                    RouterPath(state.key)
                                )
                                .description,
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
