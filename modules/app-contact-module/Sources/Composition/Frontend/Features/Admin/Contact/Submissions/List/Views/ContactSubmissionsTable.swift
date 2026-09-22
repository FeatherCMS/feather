import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct ContactSubmissionsTable: Component {
    struct State {
        let items: [AdminContactSubmissionDirectoryItem]
        let pageState: NewAdminListPageState
        let search: String
        let permissions: NewAdminListActions
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let error: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Submissions",
                        description: "Review contact form submissions."
                    )
                )
            )
            if let error = state.error {
                P(error).class("new-admin-form__error")
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
