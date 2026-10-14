import FeatherAdmin
import FeatherContracts
import HTML
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct SystemVariableTable: Component {
    struct State {
        let permissions: AdminListActions
        let variables: [Components.Schemas.SystemVariableListItemSchema]
        let pageState: AdminListPageState
        let search: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: SystemVariableRoutes.listBreadcrumb)
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
                SystemVariableTableContent(
                    variables: state.variables,
                    permissions: state.permissions,
                    pageState: state.pageState,
                    search: state.search
                )
            )
        }
        .class("cms-section")
    }
}
