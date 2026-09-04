import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct NewsletterCampaignSubscriberFormView: Leaf {
    struct State {
        let newsletterId: String
        let email: String
        let firstName: String
        let lastName: String
        let status: String
        let isEdit: Bool
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
        let editAction: String?
    }
    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1(
                state.isEdit
                    ? "Edit campaign subscriber" : "Add campaign subscriber"
            )
            if let error = state.error { P(error).class("error") }
            Form {
                Label {
                    AdminFieldLabel(label: "Email", required: true).html()
                    Input().type(.email).name("email").value(state.email)
                        .required().if(state.isEdit) { $0.readOnly() }
                }
                Label {
                    AdminFieldLabel(label: "First name", required: false).html()
                    Input().type(.text).name("firstName").value(state.firstName)
                }
                Label {
                    AdminFieldLabel(label: "Last name", required: false).html()
                    Input().type(.text).name("lastName").value(state.lastName)
                }
                Label {
                    AdminFieldLabel(label: "Status", required: true).html()
                    Select {
                        Option("Subscribed").value("subscribed")
                            .if(state.status == "subscribed") { $0.selected() }
                        Option("Unsubscribed").value("unsubscribed")
                            .if(state.status == "unsubscribed") {
                                $0.selected()
                            }
                    }
                    .name("status").class("text-input")
                }
                Div {
                    Button(state.isEdit ? "Save" : "Add subscriber")
                        .type(.submit)
                }
                .class("button-row")
            }
            .method(.post)
            .action(
                state.editAction
                    ?? (state.isEdit
                        ? "/admin/newsletters/\(state.newsletterId)/subscribers/\(state.email)/edit/"
                        : "/admin/newsletters/\(state.newsletterId)/subscribers/add/")
            )
            .class("cms-form")
        }
        .class("cms-section")
    }
}
