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

struct AdminAddBlogPostDefaultPresenter: AdminAddBlogPostPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: BlogPostForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add post",
            content: BlogPostAdd(
                state: .init(
                    form: state,
                    breadcrumb: BlogAdminRoutes.postsBreadcrumb
                )
            )
        )
    }

}
