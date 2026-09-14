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

struct AdminEditBlogAuthorLinkDefaultPresenter: AdminEditBlogAuthorLinkPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        menuId: String,
        id: String,
        state: BlogAuthorLinkForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit blog author link",
            content: BlogAuthorLinkEdit(
                state: .init(
                    menuId: menuId,
                    id: id,
                    form: state,
                    breadcrumb: breadcrumb(menuId: menuId, id: id)
                )
            )
        )
    }

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit blog author link",
            content: BlogAuthorLinkError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(menuId: menuId, id: id)
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
