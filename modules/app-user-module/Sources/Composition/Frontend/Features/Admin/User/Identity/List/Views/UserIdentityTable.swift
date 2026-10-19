import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserIdentityTable: Component {
    let permissions: AdminListActions
    let identities: [Components.Schemas.UserIdentityListItemSchema]
    let pageState: AdminListPageState
    let search: String?
    let role: String?

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(links: UserIdentityRoutes.listBreadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "User identities",
                        description:
                            "Manage identities and their assigned roles."
                    )
                )
            )
            context.build(
                UserIdentityTableContent(
                    permissions: permissions,
                    identities: identities,
                    pageState: pageState,
                    search: search,
                    role: role
                )
            )
        }
        .class("cms-section")
    }
}
