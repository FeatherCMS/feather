import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Author.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Author.Router.Routes
        let authorLinkRoutes: AuthorLink.Router.Routes

        func renderDetailsPage(
            rule: Author.Details.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Blog author details",
                content: Author.View.Component(
                    state: .init(
                        author: rule,
                        breadcrumb: routes.authorsBreadcrumb,
                        permissions: permissions,
                        routes: routes,
                        authorLinkRoutes: authorLinkRoutes
                    )
                )
            )
        }

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Blog author details",
                content: BlogAuthorError(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.authorsBreadcrumb
                    )
                )
            )
        }

    }
}
