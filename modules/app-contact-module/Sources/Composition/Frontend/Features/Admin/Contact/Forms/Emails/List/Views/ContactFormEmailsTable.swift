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
            context.build(
                AdminContactFormTabs(formId: state.id, active: .emails)
            )
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Contact form emails",
                        description:
                            "Configure delivery messages for this contact form."
                    )
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
