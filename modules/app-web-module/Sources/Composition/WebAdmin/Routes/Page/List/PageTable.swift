import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct PageTable: Component {
    struct State {
        let permissions: AdminListActions
        let pages: [AdminListPageItemModel]
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
                PageTableContent(
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
