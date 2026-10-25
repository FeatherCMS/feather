import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import SystemModule
import WebBuilders
import WebComponents

extension Permission.Edit {
    struct Page: Component {
        struct State {
            let id: String
            let isEdited: Bool
            let form: Form.State
            let moreActions: [AdminButton.State]
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
                            title: "Edit system permission",
                            description: "Update this system permission.",
                            moreActions: state.moreActions
                        )
                    )
                )
                if state.isEdited {
                    P("System permission edited successfully.")
                }
                context.build(
                    Form(
                        state: state.form,
                        action: state.routes.editPath(state.id),
                        nonceToken: state.nonceToken
                    )
                )
            }
            .class("cms-section")
        }
    }
}
