import FeatherModuleKit
import FeatherWebAdmin
import HTML
import SGML
import SystemAdminAPI
import SystemModule
import WebBuilders
import WebComponents

extension Variable.List {
    struct Page: Component {
        struct State {
            let permissions: AdminListActions
            let variables: [Components.Schemas.SystemVariableListItemSchema]
            let pageState: AdminListPageState
            let search: String?
            let routes: Variable.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(
                        links: state.routes.listBreadcrumb
                    )
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Variables",
                            description:
                                "Manage configuration values used by the application."
                        )
                    )
                )
                context.build(
                    Page.Content(
                        variables: state.variables,
                        permissions: state.permissions,
                        pageState: state.pageState,
                        search: state.search,
                        routes: state.routes
                    )
                )
            }
            .class("cms-section")
        }
    }
}
