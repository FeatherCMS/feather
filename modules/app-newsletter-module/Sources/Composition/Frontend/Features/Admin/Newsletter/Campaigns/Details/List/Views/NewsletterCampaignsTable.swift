import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import NewsletterContracts
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignsTable: Component {
    struct State {
        let items: [AdminNewsletterCampaignItem]
        let pageState: NewAdminListPageState
        let search: String?
        let actions: NewAdminListActions
        let isPicker: Bool
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminBreadcrumb(links: NewsletterAdminRoutes.breadcrumb)
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: state.isPicker
                            ? "Select newsletter campaign" : "Campaigns",
                        description: state.isPicker
                            ? "Choose a campaign to insert."
                            : "Manage newsletter campaigns."
                    )
                )
            )
            context.render(
                NewsletterCampaignsTableContent(
                    items: state.items,
                    pageState: state.pageState,
                    search: state.search,
                    actions: state.actions,
                    isPicker: state.isPicker
                )
            )
        }
        .class("cms-section")
    }
}
