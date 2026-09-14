import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import ContactContracts
import SGML
import WebBuilders
import WebComponents

struct ContactFieldsTable: Component {
    struct State {
        let fields: [AdminContactFieldRow]
        let pageState: NewAdminListPageState
        let search: String
        let error: String?
        let isEdited: Bool
        let isRemoved: Bool
        let permissions: NewAdminListActions
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
                        context.render(NewAdminPageHeader(state: .init(title: "Contact form fields", description: "Manage reusable contact form fields.")))
                        if let error = state.error { P(error).class("new-admin-form__error") }
            context.render(
                ContactFieldsTableContent(
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
