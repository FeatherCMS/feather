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

struct AdminAddBlogAuthorLinkDefaultPresenter: AdminAddBlogAuthorLinkPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        menuId: String,
        state: BlogAuthorLinkForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add blog author link",
            content: BlogAuthorLinkAdd(
                state: .init(
                    menuId: menuId,
                    form: state,
                    breadcrumb: breadcrumb(menuId: menuId)
                )
            )
        )
    }

    func breadcrumb(
        menuId: String
    ) -> [NewAdminBreadcrumb.Link] {
        BlogAdminRoutes.authorLinksBreadcrumb(RouterPath(menuId))
    }
}
