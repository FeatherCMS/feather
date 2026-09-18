import CSS
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuItemBulkConfirmation: Component {
    struct State {
        let menuId: String
        let page: Int
        let search: String?
        let items: [NewAdminRemoveItemContext]
        let nonceToken: String
    }

    let state: State

    func selectors() -> [any CSS.Selector] {
        WebMenuItemGroup.groupSelectors()
    }

    func html(context: inout BuilderContext) -> Section {
        context.build(
            NewAdminRemoveConfirmation(
                breadcrumb: WebMenuRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Edit menu",
                    description:
                        "Update the navigation menu configuration."
                ),
                selectedItems: state.items.map(\.label),
                action: WebMenuItemRoutes.remove(
                    RouterPath(state.menuId)
                ).description,
                cancel: NewAdminLocation.url(
                    path: WebMenuItemRoutes.list(
                        RouterPath(state.menuId)
                    ).description,
                    page: state.page,
                    search: state.search
                ),
                nonceToken: state.nonceToken,
                hiddenFields: state.items.map {
                    .init(name: "ids", value: $0.id)
                },
                tabBar: NewAdminTabBar(
                    links: AdminWebMenuTabs(
                        menuID: state.menuId,
                        active: .items
                    ).links
                ),
                sectionTitle: "Remove selected items",
                sectionDescription: "This action cannot be undone.",
                contentClass: "web-menu-item-group"
            )
        )
    }
}
