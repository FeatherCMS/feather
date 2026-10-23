import FeatherWebAdmin
import HTML
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

struct MenuTable: Component {
    struct State {
        let permissions: AdminListActions
        let menus: [Components.Schemas.MenuQueryItemSchema]
        let pageState: AdminListPageState
        let search: String?
        let breadcrumb: [AdminBreadcrumb.Link]
        let routes: WebModule.Menu.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Menus",
                        description:
                            "Manage navigation menus for the public website."
                    )
                )
            )
            context.build(
                MenuTableContent(
                    menus: state.menus,
                    permissions: state.permissions,
                    pageState: state.pageState,
                    search: state.search,
                    routes: state.routes
                )
            )
        }
        .class("cms-section")
    }
}
