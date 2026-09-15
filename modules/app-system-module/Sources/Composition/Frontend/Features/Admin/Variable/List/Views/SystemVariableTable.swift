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
        let permissions: NewAdminListActions
        let variables: [Components.Schemas.SystemVariableListItemSchema]
        let pageState: NewAdminListPageState
        let search: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: SystemVariableRoutes.listBreadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
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
