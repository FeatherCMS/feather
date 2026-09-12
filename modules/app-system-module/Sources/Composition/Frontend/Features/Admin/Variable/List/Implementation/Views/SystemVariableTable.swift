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
        let permissions: ListActions
        let variables: [Components.Schemas.SystemVariableListItemSchema]
        let pageState: ListPageState
        let search: String?
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(state: SystemVariableRoutes.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Variables",
                        description:
                            "Manage configuration values used by the application."
                    )
                )
            )
            context.render(
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
