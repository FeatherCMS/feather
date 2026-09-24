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
        model: NewAdminListModel<AdminNewsletterIssueItem>,
        error: String?,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse {
        if let error {
            return try await renderingEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Campaign issues",
                content: NewAdminStatusView(
                    state: .init(
                        title: "Campaign issues unavailable",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        return try await renderingEngine.renderNewAdminPage(
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
