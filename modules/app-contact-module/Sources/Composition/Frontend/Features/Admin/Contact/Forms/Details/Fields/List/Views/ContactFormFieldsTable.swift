import ContactContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormFieldsTable: Component {
    struct State {
        let formId: String
        let fields: [AdminContactFormFieldRow]
        let pageState: NewAdminListPageState
        let search: String
        let error: String?
        let permissions: NewAdminListActions
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminContactFormTabs(formId: state.formId, active: .details)
            )
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Contact form fields",
                        description:
                            "Choose and configure the fields for this contact form."
                    )
                )
            )
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(
                ContactFormFieldsTableContent(
                    formId: state.formId,
                    fields: state.fields,
                    pageState: state.pageState,
                    search: state.search,
                    permissions: state.permissions
                )
            )
        }
        .class("cms-section")
    }
}
