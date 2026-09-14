import FeatherAdmin
import Hummingbird

struct AdminListNewsletterCampaignSubscribersDefaultPresenter:
    AdminListNewsletterCampaignSubscribersPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        newsletterId: String,
        model: NewAdminListModel<AdminNewsletterCampaignSubscriberItem>,
        search: String?,
        error: String?,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        if let error {
            return try await renderingEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Campaign subscribers",
                content: NewAdminStatusView(
                    state: .init(
                        title: "Subscribers unavailable",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Campaign subscribers",
            content: NewsletterCampaignSubscribersTable(
                state: .init(
                    newsletterId: newsletterId,
                    items: model.items,
                    pageState: model.pageState,
                    search: search,
                    permissions: permissions
                )
            )
        )
    }
}
