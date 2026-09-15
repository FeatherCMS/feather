import FeatherAdmin
import HTML
import Hummingbird
import NewsletterContracts
import WebComponents

struct AdminListNewsletterCampaignsDefaultPresenter:
    AdminListNewsletterCampaignsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        model: NewAdminListModel<AdminNewsletterCampaignItem>,
        isPicker: Bool,
        error: String?,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse {
        if let error {
            return try await renderingEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Campaigns",
                content: NewAdminStatusView(
                    state: .init(
                        title: "Campaigns unavailable",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        return try await renderingEngine.renderNewAdminPage(
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
