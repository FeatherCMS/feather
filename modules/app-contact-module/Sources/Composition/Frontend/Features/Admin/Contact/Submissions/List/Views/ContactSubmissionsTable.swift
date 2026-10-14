import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct ContactSubmissionsTable: Component {
    struct State {
        let items: [AdminContactSubmissionDirectoryItem]
        let pageState: AdminListPageState
        let search: String
        let permissions: AdminListActions
        let breadcrumb: [AdminBreadcrumb.Link]
        let error: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Submissions",
                        description: "Review contact form submissions."
                    )
                )
            )
            if let error = state.error {
                P(error).class("admin-form__error")
            }
            context.build(
                ContactSubmissionsTableContent(
                    items: state.items,
                    pageState: state.pageState,
                    search: state.search,
                    permissions: state.permissions
                )
            )
        }
        .class("cms-section")
    }
}
