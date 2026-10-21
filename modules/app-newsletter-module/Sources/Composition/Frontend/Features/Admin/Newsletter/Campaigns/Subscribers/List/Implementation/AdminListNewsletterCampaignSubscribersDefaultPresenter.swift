import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminListNewsletterCampaignSubscribersDefaultPresenter:
    AdminListNewsletterCampaignSubscribersPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        newsletterId: String,
        model: AdminListModel<AdminNewsletterCampaignSubscriberItem>,
        search: String?,
        error: String?,
        permissions: AdminListActions
    ) async throws -> HTMLResponse {
        if let error {
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Campaign subscribers",
                content: AdminStatusView(
                    state: .init(
                        title: "Subscribers unavailable",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        return try await renderingEngine.renderAdminPage(
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
