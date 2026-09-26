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
                AdminContactFormHeader(
                    formId: state.key,
                    active: .details
                )
            )
            H2("Contact form details")
            context.build(
                ContactFormForm(
                    state: state.form,
                    action: ContactAdminRoutes.formEdit(RouterPath(state.key))
                        .description,
                    submitLabel: "Save changes",
                    isReadOnly: state.isReadOnly
                )
            )
        }
        .class("cms-section")
    }
}
