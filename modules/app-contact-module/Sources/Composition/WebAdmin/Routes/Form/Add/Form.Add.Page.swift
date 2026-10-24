import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.Add {
    struct Page: Component {
        struct State {
            let form: ContactModule.Form.Editor.State
            let routes: ContactModule.Form.Router.Routes
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
                    ContactModule.Form.Editor(
                        state: state.form,
                        action: state.routes.formAdd.path,
                        submitLabel: "Add form"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
