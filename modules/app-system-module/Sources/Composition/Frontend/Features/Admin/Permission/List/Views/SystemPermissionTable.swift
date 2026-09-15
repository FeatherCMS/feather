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

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: SystemPermissionRoutes.listBreadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Permissions",
                        description: "Manage system permissions."
                    )
                )
            )
            context.build(
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
