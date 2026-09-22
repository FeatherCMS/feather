import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignAddView: Component {
    struct State {
        let name: String
        let fromEmail: String
        let error: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Campaigns",
                            link: NewsletterAdminRoutes.campaigns.description
                        ),
                        .init(
                            label: "Add",
                            link: NewsletterAdminRoutes.campaignAdd.description
                        ),
                    ]
                )
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add campaign",
                        description: "Create a newsletter campaign."
                    )
                )
            )
            context.build(
                NewsletterCampaignForm(
                    state: .init(
                        name: state.name,
                        fromEmail: state.fromEmail,
                        error: state.error,
                        success: nil
                    ),
                    action: NewsletterAdminRoutes.campaignAdd.description,
                    submitLabel: "Add campaign"
                )
            )
        }
        .class("cms-section")
    }
}
