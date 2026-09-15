import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterIssuesTable: Component {
    struct State {
        let newsletterId: String
        let items: [AdminNewsletterIssueItem]
        let pageState: NewAdminListPageState
        let permissions: NewAdminListActions
        let search: String?
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
                        )
                    ]
                )
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Campaign issues",
                        description:
                            "Manage issues for this newsletter campaign."
                    )
                )
            )
            context.build(
                NewAdminTabBar(links: [
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
                        isCurrent: false
                    ),
                    .init(
                        label: "Issues",
                        href:
                            NewsletterAdminRoutes.campaignIssues(
                                RouterPath(state.newsletterId)
                            )
                            .description,
                        isCurrent: true
                    ),
                ])
            )
            context.build(
                NewsletterIssuesTableContent(
                    newsletterId: state.newsletterId,
                    items: state.items,
                    pageState: state.pageState,
                    permissions: state.permissions,
                    search: state.search
                )
            )
        }
        .class("cms-section")
    }
}
