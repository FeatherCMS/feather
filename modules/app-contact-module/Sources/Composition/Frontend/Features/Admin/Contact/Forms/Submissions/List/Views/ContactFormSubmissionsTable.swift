import ContactContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormSubmissionsTable: Component {
    struct State {
        let formId: String
        let items: [AdminContactFormSubmissionItem]
        let pageState: NewAdminListPageState
        let search: String
        let error: String?
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let permissions: NewAdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminContactFormTabs(formId: state.formId, active: .submissions)
            )
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Contact form submissions",
                        description: "Review submissions for this contact form."
                    )
                )
            )
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(
                ContactFormSubmissionsTableContent(
                    formId: state.formId,
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
