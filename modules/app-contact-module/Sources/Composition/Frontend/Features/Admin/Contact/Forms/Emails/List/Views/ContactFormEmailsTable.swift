import ContactContracts
import FeatherAdmin
import FeatherContracts
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

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminContactFormHeader(
                    formId: state.id,
                    active: .emails
                )
            )
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(
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
