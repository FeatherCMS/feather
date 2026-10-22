import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: AuthorLink.Router.Routes

        func renderDetailsPage(
            model: AuthorLink.Details.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Blog author link details",
                content: AuthorLink.View.Component(
                    state: .init(
                        model: model,
                        breadcrumb: routes.authorLinksBreadcrumb(
                            RouterPath(model.authorID)
                        ),
                        permissions: permissions,
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(
            authorID: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Blog author link details",
                content: BlogAuthorLinkError(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.authorLinksBreadcrumb(
                            RouterPath(authorID)
                        )
                    )
                )
            )
        }
    }
}
