import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct NewsletterEdit: Component {
    struct State {
        let id: String
        let isEdited: Bool
        let form: NewsletterForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                AdminNewsletterCampaignTabs(
                    campaignId: state.id,
                    active: .details
                )
            )
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Edit campaign")
            if state.isEdited { P("Campaign edited successfully.") }
            context.render(
                NewsletterForm(
                    state: state.form,
                    action: "/admin/newsletters/\(state.id)/edit/",
                    submitLabel: "Save"
                )
            )
        }
        .class("cms-section")
    }
}
