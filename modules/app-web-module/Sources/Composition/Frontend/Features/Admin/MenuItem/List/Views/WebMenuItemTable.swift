import FeatherAdmin
import HTML
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuItemTable: Component {
    struct State {
        let menuId: String
        let permissions: NewAdminListActions
        let items: [Components.Schemas.WebMenuItemListItemSchema]
        let pageState: NewAdminListPageState
        let search: String?
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Menu items",
                        description:
                            "Manage the links and order in this navigation menu."
                    )
                )
            )
            context.build(
                AdminWebMenuTabs(menuID: state.menuId, active: .items)
            )
            context.build(
                WebMenuItemTableContent(
                    state: .init(
                        menuId: state.menuId,
                        permissions: state.permissions,
                        items: state.items,
                        pageState: state.pageState,
                        search: state.search
                    )
                )
            )
        }
        .class("cms-section")
    }
}
