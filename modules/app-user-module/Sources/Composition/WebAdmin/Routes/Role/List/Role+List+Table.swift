import FeatherWebAdmin
import HTML
import SGML
import UserAdminAPI
import UserModule
import WebBuilders
import WebComponents

extension Role.List {
    struct TableView: Component {
        let routes: Role.Router.Routes
        let permissions: AdminListActions
        let roles: [Components.Schemas.UserRoleListItemSchema]
        let pageState: AdminListPageState
        let search: String?

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.listBreadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "User roles",
                            description:
                                "Manage roles assigned to user identities."
                        )
                    )
                )
                context.build(
                    Role.List.TableContent(
                        routes: routes,
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
}
