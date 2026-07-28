import HTML
import SGML
import WebStandards

struct NewsletterEdit: Component {
    struct State {
        let id: String
        let isEdited: Bool
        let form: NewsletterForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminNewsletterCampaignTabs(campaignId: state.id, active: .details)
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Edit campaign")
            if state.isEdited { P("Campaign edited successfully.") }
            NewsletterForm(
                state: state.form,
                action: "/admin/newsletters/\(state.id)/edit/",
                submitLabel: "Save"
            )
        }
        .class("cms-section")
    }
}
