import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule
import NewsletterApplication

extension Campaign.Search.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            model: Campaign.Search.Model,
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
                content: Campaign.Search.Table(
                    state: .init(
                        items: model.items,
                        pageState: model.pageState,
                        search: search,
                        actions: permissions,
                        isPicker: isPicker,
                        routes: routes
                    ),
                )
            )
        }
    }
}
