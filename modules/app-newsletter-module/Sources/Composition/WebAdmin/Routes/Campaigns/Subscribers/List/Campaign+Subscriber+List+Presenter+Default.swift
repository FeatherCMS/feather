import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            newsletterId: String,
            model: AdminListModel<Campaign.Subscriber.Item>,
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
                content: Campaign.Subscriber.List.View(
                    state: .init(
                        newsletterId: newsletterId,
                        items: model.items,
                        pageState: model.pageState,
                        search: search,
                        permissions: permissions,
                        routes: routes
                    )
                )
            )
        }
    }
}
