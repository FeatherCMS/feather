import FeatherAdmin
import HTML
import SGML
import UserAdminAPI
import WebBuilders
import WebComponents

struct UserRoleTable: Component {
    let permissions: AdminListActions
    let roles: [Components.Schemas.UserRoleListItemSchema]
    let pageState: AdminListPageState
    let search: String?

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: UserRoleRoutes.listBreadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "User roles",
                        description: "Manage roles assigned to user identities."
                    )
                )
            )
            context.build(
                UserRoleTableContent(
                    roles: roles,
                    permissions: permissions,
                    pageState: pageState,
                    search: search
                )
            )
        }
        .class("cms-section")
    }
}
