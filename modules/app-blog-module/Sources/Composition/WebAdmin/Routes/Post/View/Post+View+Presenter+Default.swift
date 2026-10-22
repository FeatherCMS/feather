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

extension Post.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: BlogWebAdmin.Router.Routes

        func renderDetailsPage(
            rule: Post.View.Details.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Blog post details",
                content: Post.View.Details.Component(
                    state: .init(
                        rule: rule,
                        breadcrumb: routes.postsBreadcrumb,
                        permissions: permissions,
                        routes: routes
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
                title: "Blog post details",
                content: BlogPostError(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.postsBreadcrumb
                    )
                )
            )
        }

    }
}
