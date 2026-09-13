import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserIdentityTable: Component {
    let permissions: NewAdminListActions
    let identities: [Components.Schemas.UserIdentityListItemSchema]
    let pageState: NewAdminListPageState
    let search: String?
    let role: String?

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: UserIdentityRoutes.listBreadcrumb))
            context.render(NewAdminPageHeader(state: .init(title: "User identities", description: "Manage identities and their assigned roles.")))
            context.render(UserIdentityTableContent(permissions: permissions, identities: identities, pageState: pageState, search: search, role: role))
        }.class("cms-section")
    }
}
