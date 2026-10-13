import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminViewBlogAuthorDefaultPresenter: AdminViewBlogAuthorPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: BlogAuthorDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Blog author details",
            content: BlogAuthorDetails(
                state: .init(
                    author: rule,
                    breadcrumb: BlogAdminRoutes.authorsBreadcrumb,
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
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Blog author details",
            content: BlogAuthorError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: BlogAdminRoutes.authorsBreadcrumb
                )
            )
        )
    }

}
