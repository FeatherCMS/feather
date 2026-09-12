import FeatherAdmin
import FeatherContracts
import HTML
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct SystemPermissionTable: Component {
    struct State {
        let permissions: NewAdminListActions
        let permissionsList: [Components.Schemas.SystemPermissionListItemSchema]
        let pageState: NewAdminListPageState
        let search: String?
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminBreadcrumb(state: SystemPermissionRoutes.breadcrumb)
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Permissions",
                        description: "Manage system permissions."
                    )
                )
            )
            context.render(
                SystemPermissionTableContent(
                    permissions: state.permissionsList,
                    actions: state.permissions,
                    pageState: state.pageState,
                    search: state.search
                )
            )
        }
        .class("cms-section")
    }
}
