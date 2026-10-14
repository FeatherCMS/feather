import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct WebPageTable: Component {
    struct State {
        let permissions: AdminListActions
        let pages: [AdminListWebPageItemModel]
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
                        title: "Web pages",
                        description:
                            "Manage the pages published on the website."
                    )
                )
            )
            context.build(
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
