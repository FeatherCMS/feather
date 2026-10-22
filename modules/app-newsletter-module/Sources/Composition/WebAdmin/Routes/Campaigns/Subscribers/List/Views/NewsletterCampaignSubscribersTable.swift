import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignSubscribersTable: Component {
    struct State {
        let newsletterId: String
        let items: [AdminNewsletterCampaignSubscriberItem]
        let pageState: AdminListPageState
        let search: String?
        let permissions: AdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(
                    links: NewsletterAdminRoutes.breadcrumb + [
                        .init(
                            label: "Campaigns",
                            link: NewsletterAdminRoutes.campaigns.description
                        )
                    ]
                )
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Campaign subscribers",
                        description: "Manage subscribers for this campaign."
                    )
                )
            )
            context.build(
                NewsletterCampaignTabs(
                    id: state.newsletterId,
                    active: .subscribers
                )
            )
            context.build(
                AdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Subscribers",
                        description:
                            "Manage the subscribers linked to this campaign."
                    )
                ) {
                    context.build(
                        NewsletterCampaignSubscribersTableContent(
                            newsletterId: state.newsletterId,
                            items: state.items,
                            pageState: state.pageState,
                            search: state.search,
                            permissions: state.permissions
                        )
                    )
                }
            )
        }
        .class("cms-section")
    }
}
