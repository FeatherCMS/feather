import FeatherWebAdmin
import HTML
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

extension MenuItem.List {
    struct Page: WebComponents.Component {
        struct State {
            let menuId: String
            let permissions: AdminListActions
            let items: [Components.Schemas.MenuItemQueryItemSchema]
            let pageState: AdminListPageState
            let search: String?
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: MenuItem.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit menu",
                            description:
                                "Update the navigation menu configuration."
                        )
                    )
                )
                context.build(
                    MenuItem.TabBar(
                        active: .items,
                        detailsPath: state.routes.menu.editPath(state.menuId),
                        itemsPath: state.routes.itemsPath(state.menuId)
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Menu items",
                            description:
                                "Manage the links and order in this navigation menu."
                        )
                    ) {
                        context.build(
                            MenuItem.List.Page.Content(
                                state: .init(
                                    menuId: state.menuId,
                                    permissions: state.permissions,
                                    items: state.items,
                                    pageState: state.pageState,
                                    search: state.search,
                                    routes: state.routes
                                )
                            )
                        )
                    }
                )
            }
            .class("cms-section")
        }
    }
}
