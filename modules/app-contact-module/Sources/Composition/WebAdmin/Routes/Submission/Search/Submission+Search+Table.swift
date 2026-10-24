import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import SGML
import WebBuilders
import WebComponents

extension Submission.Search {
    struct Table: Component {
        struct State {
            let items: [Submission.Search.Model.Item]
            let pageState: AdminListPageState
            let search: String
            let formKey: String?
            let permissions: AdminListActions
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Submission.Router.Routes
            let error: String?
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: state.formKey == nil
                                ? "Submissions"
                                : "Contact form submissions",
                            description: state.formKey == nil
                                ? "Review contact form submissions."
                                : "Review submissions received through this contact form."
                        )
                    )
                )
                if let formKey = state.formKey {
                    context.build(
                        ContactModule.Form.TabBar(
                            formId: formKey,
                            active: .submissions
                        )
                    )
                }
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                context.build(
                    Content(
                        items: state.items,
                        pageState: state.pageState,
                        search: state.search,
                        formKey: state.formKey,
                        routes: state.routes,
                        permissions: state.permissions
                    )
                )
            }
            .class("cms-section")
        }
    }
}
