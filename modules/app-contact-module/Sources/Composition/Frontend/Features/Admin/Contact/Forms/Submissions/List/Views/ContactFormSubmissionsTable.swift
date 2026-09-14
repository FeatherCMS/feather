import FeatherAdmin
import FeatherContracts
import ContactContracts
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

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminContactFormTabs(formId: state.formId, active: .submissions))
                        context.render(NewAdminBreadcrumb(links: state.breadcrumb))
                        context.render(NewAdminPageHeader(state: .init(title: "Contact form submissions", description: "Review submissions for this contact form.")))
                        if let error = state.error { P(error).class("new-admin-form__error") }
            context.render(
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
