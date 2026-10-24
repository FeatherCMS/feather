import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsAdminAPI
import NewsApplication
import NewsModule

extension Article.Detail.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Article.Router.Routes

        func renderDetails(
            item: Components.Schemas.NewsArticleDetailSchema
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: item.title,
                content: Article.Detail.Page(
                    item: item,
                    permissions: context.currentUserAdminListActions,
                    routes: routes
                )
            )
        }

        func renderError(_ message: String) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "News article",
                content: News.Error.Page(
                    breadcrumb: routes.breadcrumb,
                    title: "News article unavailable",
                    message: message
                )
            )
        }
    }
}
