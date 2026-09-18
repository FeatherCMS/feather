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

struct WebMenuItemConfirmation: Component {

    struct State {
        let menuId: String
        let id: String
        let label: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let nonceToken: String
        let origin: WebMenuItemRoutes.RemoveOrigin
    }

    let state: State

    func selectors() -> [any CSS.Selector] {
        WebMenuItemGroup.groupSelectors()
    }

    func html(context: inout BuilderContext) -> Section {
        context.build(
            NewAdminRemoveConfirmation(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Edit menu",
                    description: "Update the navigation menu configuration."
                ),
                selectedItems: [state.label],
                action:
                    WebMenuItemRoutes.itemRemove(
                        RouterPath(state.menuId),
                        RouterPath(state.id),
                        origin: state.origin
                    ),
                cancel: WebMenuItemRoutes.removeCancel(
                    RouterPath(state.menuId),
                    RouterPath(state.id),
                    origin: state.origin
                ),
                submitLabel: "Remove item",
                nonceToken: state.nonceToken,
                hiddenFields: [.init(name: "ids", value: state.id)],
                tabBar: NewAdminTabBar(
                    links: AdminWebMenuTabs(
                        menuID: state.menuId,
                        active: .items
                    )
                    .links
                ),
                sectionHeader: .init(
                    title: "Remove item",
                    description: "This action cannot be undone.",
                    level: 2,
                    showSeparator: true
                ),
                contentClass: "web-menu-item-group"
            )
        )
    }
}
