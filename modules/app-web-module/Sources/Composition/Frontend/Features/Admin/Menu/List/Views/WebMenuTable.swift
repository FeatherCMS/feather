import FeatherAdmin
import HTML
import SGML
import WebAdminAPI
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

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Menus",
                        description:
                            "Manage navigation menus for the public website."
                    )
                )
            )
            context.build(
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
