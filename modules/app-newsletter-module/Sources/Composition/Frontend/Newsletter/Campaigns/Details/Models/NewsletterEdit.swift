import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct NewsletterEdit: Leaf {
    struct State {
        let id: String
        let isEdited: Bool
        let form: NewsletterForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminNewsletterCampaignTabs(campaignId: state.id, active: .details).renderHTML()
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Edit campaign")
            if state.isEdited { P("Campaign edited successfully.") }
            NewsletterForm(
                state: state.form,
                action: "/admin/newsletters/\(state.id)/edit/",
                submitLabel: "Save"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
