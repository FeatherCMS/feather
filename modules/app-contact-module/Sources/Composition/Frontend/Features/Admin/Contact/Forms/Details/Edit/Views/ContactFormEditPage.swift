import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormEditPage: Component {
    struct State {
        let id: String
        let isReadOnly: Bool
        let form: ContactFormForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminContactFormTabs(formId: state.id, active: .details)
            )
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: state.isReadOnly
                            ? "Contact form" : "Edit contact form",
                        description: state.isReadOnly
                            ? "Review form settings and field order."
                            : "Update form settings and field order."
                    )
                )
            )
            context.build(
                ContactFormForm(
                    state: state.form,
                    action: ContactAdminRoutes.formEdit(RouterPath(state.id))
                        .description,
                    submitLabel: "Save changes",
                    isReadOnly: state.isReadOnly
                )
            )
        }
        .class("cms-section")
    }
}
