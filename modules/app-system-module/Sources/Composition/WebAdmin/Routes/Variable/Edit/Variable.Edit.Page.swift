import FeatherWebAdmin
import HTML
import SGML
import SystemModule
import WebBuilders
import WebComponents

extension Variable.Edit {
    struct Page: Component {
        struct State {
            let routes: Variable.Router.Routes
            let id: String
            let form: Form
            let moreActions: [AdminButton.State]
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
                            title: "Edit system variable",
                            description:
                                "Update this configuration value used by the application.",
                            moreActions: state.moreActions
                        )
                    )
                )
                context.build(state.form)
            }
            .class("cms-section")
        }
    }
}
