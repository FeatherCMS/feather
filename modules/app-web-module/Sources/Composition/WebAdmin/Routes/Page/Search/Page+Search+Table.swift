import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents
import WebModule

extension Page.Search {
    struct Table: Component {
        struct State {
            let permissions: AdminListActions
            let pages: [Item]
            let pageState: AdminListPageState
            let search: String?
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Page.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Web pages",
                            description:
                                "Manage the pages published on the website."
                        )
                    )
                )
                context.build(
                    Content(
                        pages: state.pages,
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
}
