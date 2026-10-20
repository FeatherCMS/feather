import FeatherWebAdmin
import FeatherModuleKit
import HTML
import SGML
import SystemAdminAPI
import SystemModule
import WebBuilders
import WebComponents

struct SystemPermissionTable: Component {
    struct State {
        let permissions: AdminListActions
        let permissionsList: [Components.Schemas.SystemPermissionListItemSchema]
        let pageState: AdminListPageState
        let search: String?
        let routes: Permission.Router.Routes
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
                    search: state.search,
                    routes: state.routes
                )
            )
        }
        .class("cms-section")
    }
}
