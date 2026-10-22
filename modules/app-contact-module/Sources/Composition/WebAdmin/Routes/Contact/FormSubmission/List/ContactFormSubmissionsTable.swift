import ContactModule
import FeatherWebAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormSubmissionsTable: Component {
    struct State {
        let formId: String
        let items: [AdminContactFormSubmissionItem]
        let pageState: AdminListPageState
        let search: String
        let error: String?
        let breadcrumb: [AdminBreadcrumb.Link]
        let permissions: AdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Contact form submissions",
                        description: "Review submissions for this contact form."
                    )
                )
            )
            context.build(
                AdminContactFormTabs(
                    formId: state.formId,
                    active: .submissions
                )
            )
            context.build(
                AdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Submissions",
                        description:
                            "Review submissions received through this contact form."
                    )
                ) {
                    if let error = state.error {
                        P(error).class("admin-form__error")
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
            )
        }
        .class("cms-section")
    }
}
