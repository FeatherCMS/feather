import ContactContracts
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFieldsTable: Component {
    struct State {
        let fields: [AdminContactFieldRow]
        let forms: [AdminContactFormFilterOption]
        let formKey: String?
        let pageState: AdminListPageState
        let search: String
        let error: String?
        let permissions: AdminListActions
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Contact form fields",
                        description: "Manage reusable contact form fields."
                    )
                )
            )
            if let error = state.error {
                P(error).class("admin-form__error")
            }
            context.build(
                ContactFieldsTableContent(
                    fields: state.fields,
                    forms: state.forms,
                    formKey: state.formKey,
                    pageState: state.pageState,
                    search: state.search,
                    permissions: state.permissions
                )
            )
        }
        .class("cms-section")
    }
}
