import FeatherWebAdmin
import Hummingbird

struct AdminListNewsletterCampaignsDefaultPresenter:
    AdminListNewsletterCampaignsPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        model: AdminListModel<AdminNewsletterCampaignItem>,
        isPicker: Bool,
        error: String?,
        permissions: AdminListActions,
        search: String?
    ) async throws -> HTMLResponse {
        if let error {
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Campaigns",
                content: AdminStatusView(
                    state: .init(
                        title: "Campaigns unavailable",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        return try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: isPicker ? "Select newsletter campaign" : "Campaigns",
            content: NewsletterCampaignsTable(
                state: .init(
                    items: model.items,
                    pageState: model.pageState,
                    search: search,
                    actions: permissions,
                    isPicker: isPicker
                )
            )
        )
    }
}
