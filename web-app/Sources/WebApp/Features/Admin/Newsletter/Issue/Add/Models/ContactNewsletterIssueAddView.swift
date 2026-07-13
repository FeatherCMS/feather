import HTML
import SGML
import WebStandards

struct ContactNewsletterIssueAddView: Component {
    struct State { let subject: String; let content: String; let scheduledAt: String; let newsletterId: String; let error: String?; let breadcrumb: AdminBreadcrumb.State }
    let state: State
    func content() -> some BasicTag {
        Section {
            AdminNewsletterCampaignTabs(campaignId: state.newsletterId, active: .issues)
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Add campaign issue")
            if let error = state.error { P(error).class("error") }
            Form {
                Label { AdminFieldLabel(label: "Subject", required: true); Input().type(.text).class("text-input").name("subject").value(state.subject).required() }
                Label { AdminFieldLabel(label: "Content", required: true); Textarea(state.content).class("text-input").name("content").required() }
                Label { AdminFieldLabel(label: "Schedule (optional)", required: false); Input().type(.text).class("text-input").name("scheduledAt").value(state.scheduledAt).placeholder("Unix timestamp") }
                Div { Button("Add").type(.submit) }.class("button-row")
            }.method(.post).action("/admin/newsletters/\(state.newsletterId)/issues/add/").class("cms-form")
        }.class("cms-section")
    }
}
