import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignHeader: Component {
    enum Tab: Sendable, Equatable {
        case details
        case subscribers
        case issues
    }

    let campaignId: String
    let active: Tab

    func html(context: inout BuilderContext) -> Div {
        Div {
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Newsletter campaign",
                        description:
                            "Manage this campaign, its subscribers, and issues."
                    )
                )
            )
            context.build(
                NewAdminTabBar(links: [
                    .init(
                        label: "Details",
                        href:
                            NewsletterAdminRoutes.campaignDetails(
                                RouterPath(campaignId)
                            )
                            .description,
                        isCurrent: active == .details
                    ),
                    .init(
                        label: "Subscribers",
                        href:
                            NewsletterAdminRoutes.campaignSubscribers(
                                RouterPath(campaignId)
                            )
                            .description,
                        isCurrent: active == .subscribers
                    ),
                    .init(
                        label: "Issues",
                        href:
                            NewsletterAdminRoutes.campaignIssues(
                                RouterPath(campaignId)
                            )
                            .description,
                        isCurrent: active == .issues
                    ),
                ])
            )
        }
    }
}
