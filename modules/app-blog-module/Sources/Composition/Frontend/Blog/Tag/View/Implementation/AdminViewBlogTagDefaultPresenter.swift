import BlogAdminAPI
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

struct AdminViewBlogTagDefaultPresenter: AdminViewBlogTagPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: BlogTagDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Blog tag details",
            content: BlogTagDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: BlogAdminRoutes.tagsBreadcrumb,
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
            title: "Blog tag details",
            content: BlogTagError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: BlogAdminRoutes.tagsBreadcrumb
                )
            )
        )
    }

}
