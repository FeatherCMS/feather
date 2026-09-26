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
                NewsletterCampaignHeader(
                    campaignId: state.newsletterId,
                    active: .subscribers
                )
            )
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
        .class("cms-section")
    }
}
