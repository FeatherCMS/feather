import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

extension Category.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Category.Router.Routes

        func renderList(
            model: Category.List.Model,
            search: String,
            error: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "News categories",
                content: Category.List.Page(
                    model: model,
                    search: search,
                    error: error,
                    permissions: context.currentUserAdminListActions,
                    canAccess: context.isCurrentUserAllowed(
                        to: Category.Permissions.list
                    ),
                    routes: routes
                )
            )
        }
    }
}
