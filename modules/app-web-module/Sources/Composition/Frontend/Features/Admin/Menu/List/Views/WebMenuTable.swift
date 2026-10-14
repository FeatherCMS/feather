import FeatherAdmin
import HTML
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuTable: Component {
    struct State {
        let permissions: AdminListActions
        let menus: [Components.Schemas.WebMenuListItemSchema]
        let pageState: AdminListPageState
        let search: String?
        let breadcrumb: [AdminBreadcrumb.Link]
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
