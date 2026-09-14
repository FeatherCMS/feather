import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct WebPageTable: Component {
    struct State {
        let permissions: NewAdminListActions
        let pages: [AdminListWebPageItemModel]
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
                        title: "Web pages",
                        description:
                            "Manage the pages published on the website."
                    )
                )
            )
            context.render(
                WebPageTableContent(
                    pages: state.pages,
                    permissions: state.permissions,
                    pageState: state.pageState,
                    search: state.search
                )
            )
        }
        .class("cms-section")
    }
}
