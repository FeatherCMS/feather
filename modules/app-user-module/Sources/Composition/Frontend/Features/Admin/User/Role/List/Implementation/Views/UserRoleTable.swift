import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserRoleTable: Component {
    let permissions: NewAdminListActions
    let roles: [Components.Schemas.UserRoleListItemSchema]
    let pageState: NewAdminListPageState
    let search: String?

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: UserRoleRoutes.listBreadcrumb))
            context.render(NewAdminPageHeader(state: .init(title: "User roles", description: "Manage roles assigned to user identities.")))
            context.render(UserRoleTableContent(roles: roles, permissions: permissions, pageState: pageState, search: search))
        }
        .class("cms-section")
    }
}
