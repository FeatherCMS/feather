import FeatherAdmin
import HTML
import Hummingbird
import WebComponents

struct NewsletterCampaignTabs: Component {
    enum Tab: Equatable {
        case details
        case subscribers
        case issues
    }

    let id: String
    let active: Tab

    var links: [NewAdminTabBar.Link] {
        [
            .init(
                label: "Details",
                href:
                    NewsletterAdminRoutes.campaignDetails(RouterPath(id))
                    .description,
                isCurrent: active == .details
            ),
            .init(
                label: "Subscribers",
                href:
                    NewsletterAdminRoutes.campaignSubscribers(RouterPath(id))
                    .description,
                isCurrent: active == .subscribers
            ),
            .init(
                label: "Issues",
                href:
                    NewsletterAdminRoutes.campaignIssues(RouterPath(id))
                    .description,
                isCurrent: active == .issues
            ),
        ]
    }

    func html(context: inout BuilderContext) -> Div {
        context.build(NewAdminTabBar(links: links))
    }
}
