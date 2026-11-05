import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Search.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            newsletterId: String,
            model: AdminListModel<Issue.Search.Item>,
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
                content: Issue.Search.Table(
                    state: .init(
                        newsletterId: newsletterId,
                        items: model.items,
                        pageState: model.pageState,
                        permissions: permissions,
                        search: search,
                        routes: routes
                    )
                )
            )
        }
    }
}
