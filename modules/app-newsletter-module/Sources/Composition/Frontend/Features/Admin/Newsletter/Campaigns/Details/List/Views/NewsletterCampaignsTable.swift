import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct NewsletterCampaignsTable: Component {
    struct State {
        let items: [AdminNewsletterCampaignItem]
        let pageState: NewAdminListPageState
        let search: String?
        let actions: NewAdminListActions
        let isPicker: Bool
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: NewsletterAdminRoutes.breadcrumb)
            )
            context.build(
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
            context.build(
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
