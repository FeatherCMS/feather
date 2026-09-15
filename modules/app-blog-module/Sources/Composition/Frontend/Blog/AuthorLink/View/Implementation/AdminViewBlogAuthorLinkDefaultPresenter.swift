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
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Blog author link details",
            content: BlogAuthorLinkDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: BlogAdminRoutes.authorLinksBreadcrumb(
                        RouterPath(rule.menuId)
                    ),
                    permissions: permissions
                )
            )
        )
    }

    func renderErrorPage(
        menuId: String,
        info: String,
        message: String,
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
                    breadcrumb: BlogAdminRoutes.authorLinksBreadcrumb(
                        RouterPath(menuId)
                    )
                )
            )
        )
    }

}
