import FeatherAdmin
import HTML
import WebAdminAPI
import SGML
import WebBuilders
import WebComponents

struct WebMenuTable: Component {
    struct State {
        let permissions: NewAdminListActions
        let menus: [Components.Schemas.WebMenuListItemSchema]
        let pageState: NewAdminListPageState
        let search: String?
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Menus",
                        description: "Manage navigation menus for the public website."
                    )
                )
            )
            context.render(
                WebMenuTableContent(
                    menus: state.menus,
                    permissions: state.permissions,
                    pageState: state.pageState,
                    search: state.search
                )
            )
        }
        .class("cms-section")
    }
}
