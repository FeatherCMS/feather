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
        let permissions: Set<PermissionKey>
        let variables: [Components.Schemas.SystemVariableListItemSchema]
        let pageState: ListPageState
        let search: String
        let breadcrumb: NewAdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        let permissions = ListActions(state.permissions)
        return Section {
            context.render(NewAdminBreadcrumb(state: state.breadcrumb))
            if !permissions.allows(SystemPermissions.Variables.list) {
                context.render(
                    NewAdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message:
                                "Your account cannot access system variables."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            else {
                H1("System variables")
                context.render(
                    SystemVariableTableContent(
                        variables: state.variables,
                        permissions: permissions,
                        pageState: state.pageState,
                        search: state.search
                    )
                )
            }
        }
        .class("cms-section")
    }
}
