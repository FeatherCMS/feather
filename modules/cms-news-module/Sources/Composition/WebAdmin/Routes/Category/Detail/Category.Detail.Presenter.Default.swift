import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Detail.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Category.Router.Routes

        func renderDetails(
            item: Category.Detail.Model
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: item.title,
                content: Category.Detail.Page(
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
                title: "News category",
                content: News.Error.Page(
                    breadcrumb: routes.breadcrumb,
                    title: "News category unavailable",
                    message: message
                )
            )
        }
    }
}
