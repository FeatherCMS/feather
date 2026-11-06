import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import SystemModule
import WebBuilders
import WebComponents

extension Permission.Add {
    struct Page: Component {
        struct State {
            let form: Form.State
            let nonceToken: String?
            let routes: Permission.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(
                        links: state.routes.breadcrumb
                    )
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add system permission",
                            description: "Create a system permission."
                        )
                    )
                )
                context.build(
                    Form(
                        state: state.form,
                        action: state.routes.add.path,
                        nonceToken: state.nonceToken
                    )
                )
            }
            .class("cms-section")
        }
    }
}
