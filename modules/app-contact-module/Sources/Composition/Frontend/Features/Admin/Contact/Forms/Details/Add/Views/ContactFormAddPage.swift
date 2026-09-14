import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormAddPage: Component {
    struct State {
        let form: ContactFormForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add contact form",
                        description:
                            "Create a reusable contact form and choose its fields."
                    )
                )
            )
            context.render(
                ContactFormForm(
                    state: state.form,
                    action: ContactAdminRoutes.formAdd.description,
                    submitLabel: "Add form"
                )
            )
        }
        .class("cms-section")
    }
}
