import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Article.Router.Routes

        func renderList(
            model: Article.List.Model,
            search: String,
            error: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "News articles",
                content: NewsModule.Article.List.Page(
                    model: model,
                    search: search,
                    error: error,
                    permissions: context.currentUserAdminListActions,
                    canAccess: context.isCurrentUserAllowed(
                        to: Article.Permissions.list
                    ),
                    routes: routes
                )
            )
        }
    }
}
