import FeatherAdmin
import FeatherContracts
import ContactContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormEmailsTable: Component {
    struct State {
        let id: String
        let mails: [AdminContactFormEmail]
        let permissions: NewAdminListActions
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let error: String?
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminContactFormTabs(formId: state.id, active: .emails))
                        context.render(NewAdminBreadcrumb(links: state.breadcrumb))
                        context.render(NewAdminPageHeader(state: .init(title: "Contact form emails", description: "Configure delivery messages for this contact form.")))
                        if let error = state.error { P(error).class("new-admin-form__error") }
            context.render(
                ContactFormEmailsTableContent(
                id: state.id,
                mails: state.mails,
                permissions: state.permissions
                )
            )
        }
        .class("cms-section")
    }
}
