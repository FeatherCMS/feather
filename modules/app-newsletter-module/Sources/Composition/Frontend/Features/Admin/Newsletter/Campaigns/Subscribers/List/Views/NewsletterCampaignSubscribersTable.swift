import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignSubscribersTable: Component {
    struct State {
        let newsletterId: String
        let items: [AdminNewsletterCampaignSubscriberItem]
        let pageState: NewAdminListPageState
        let search: String?
        let permissions: NewAdminListActions
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Campaigns",
                            link: NewsletterAdminRoutes.campaigns.description
                        )
                    ]
                )
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Campaign subscribers",
                        description: "Manage subscribers for this campaign."
                    )
                )
            )
            context.render(
                NewAdminPillTab(links: [
                    .init(
                        label: "Details",
                        href:
                            NewsletterAdminRoutes.campaignDetails(
                                RouterPath(state.newsletterId)
                            )
                            .description,
                        isCurrent: false
                    ),
                    .init(
                        label: "Subscribers",
                        href:
                            NewsletterAdminRoutes.campaignSubscribers(
                                RouterPath(state.newsletterId)
                            )
                            .description,
                        isCurrent: true
                    ),
                    .init(
                        label: "Issues",
                        href:
                            NewsletterAdminRoutes.campaignIssues(
                                RouterPath(state.newsletterId)
                            )
                            .description,
                        isCurrent: false
                    ),
                ])
            )
            context.render(
                NewsletterCampaignSubscribersTableContent(
                    newsletterId: state.newsletterId,
                    items: state.items,
                    pageState: state.pageState,
                    search: state.search,
                    permissions: state.permissions
                )
            )
        }
        .class("cms-section")
    }
}
