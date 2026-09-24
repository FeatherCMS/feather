import FeatherAdmin
import HTML
import SGML
import UserAdminAPI
import WebBuilders
import WebComponents

struct UserRoleTable: Component {
    let permissions: NewAdminListActions
    let roles: [Components.Schemas.UserRoleListItemSchema]
    let pageState: NewAdminListPageState
    let search: String?

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: UserRoleRoutes.listBreadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
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
