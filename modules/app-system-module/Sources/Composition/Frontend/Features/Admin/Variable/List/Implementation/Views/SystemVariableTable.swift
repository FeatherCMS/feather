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
        let breadcrumb: NewAdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        return Section {
            context.render(NewAdminBreadcrumb(state: state.breadcrumb))
            H1("Variables")
            P("Manage configuration values used across the Feather application.")
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
