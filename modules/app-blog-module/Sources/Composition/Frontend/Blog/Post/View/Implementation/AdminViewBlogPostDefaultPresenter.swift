import BlogAdminAPI
import FeatherWebShared
import BlogAppAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminViewBlogPostDefaultPresenter: AdminViewBlogPostPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: BlogPostDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Blog post details",
            content: BlogPostDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: BlogAdminRoutes.postsBreadcrumb,
                    permissions: permissions
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
                    breadcrumb: BlogAdminRoutes.postsBreadcrumb
                )
            )
        )
    }

}
