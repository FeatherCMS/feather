import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormAddPage: Component {
    struct State {
        let form: ContactFormForm.State
        let routes: Contact.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: state.routes.formsBreadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add contact form",
                        description:
                            "Create a reusable contact form and choose its fields."
                    )
                )
            )
            context.build(
                ContactFormForm(
                    state: state.form,
                    action: state.routes.formAdd.path,
                    submitLabel: "Add form"
                )
            )
        }
        .class("cms-section")
    }
}
