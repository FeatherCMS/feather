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

struct AdminViewBlogAuthorLinkDefaultPresenter: AdminViewBlogAuthorLinkPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: BlogAuthorLinkDetailsModel,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Blog author link details",
            content: BlogAuthorLinkDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: breadcrumb,
                    permissions: permissions
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Blog author link details",
            content: BlogAuthorLinkError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func breadcrumb(
        menuId: String,
        id: String
    ) -> [NewAdminBreadcrumb.Link] {
        BlogAdminRoutes.authorLinksBreadcrumb(RouterPath(menuId))
    }
}
