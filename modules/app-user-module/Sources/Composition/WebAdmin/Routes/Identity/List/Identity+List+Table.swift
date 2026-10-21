import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserModule
import WebBuilders
import WebComponents

extension Identity.List {
    struct TableView: Component {
        let routes: Identity.Router.Routes
        let permissions: AdminListActions
        let identities: [Components.Schemas.UserIdentityQueryItemSchema]
        let pageState: AdminListPageState
        let search: String?
        let role: String?

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.listBreadcrumb)
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
                    Identity.List.TableContent(
                        routes: routes,
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
}
