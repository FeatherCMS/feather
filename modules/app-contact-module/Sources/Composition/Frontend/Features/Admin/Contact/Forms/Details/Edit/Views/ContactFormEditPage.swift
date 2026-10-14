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
        let breadcrumb: [AdminBreadcrumb.Link]
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
                            ? "Review form settings and field order."
                            : "Update form settings and field order."
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
                            "Configure the form settings and selected fields."
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
