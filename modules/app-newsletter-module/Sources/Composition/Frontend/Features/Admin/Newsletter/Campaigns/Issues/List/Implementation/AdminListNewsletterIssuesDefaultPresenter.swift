import FeatherAdmin
import Hummingbird

struct AdminListNewsletterIssuesDefaultPresenter:
    AdminListNewsletterIssuesPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        newsletterId: String,
        model: AdminListModel<AdminNewsletterIssueItem>,
        error: String?,
        permissions: AdminListActions,
        search: String?
    ) async throws -> HTMLResponse {
        if let error {
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Campaign issues",
                content: AdminStatusView(
                    state: .init(
                        title: "Campaign issues unavailable",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        return try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Campaign issues",
            content: NewsletterIssuesTable(
                state: .init(
                    newsletterId: newsletterId,
                    items: model.items,
                    pageState: model.pageState,
                    permissions: permissions,
                    search: search
                )
            )
        )
    }
}
