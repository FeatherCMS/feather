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

struct AdminAddBlogAuthorDefaultPresenter: AdminAddBlogAuthorPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: BlogAuthorForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add author",
            content: BlogAuthorAdd(
                state: .init(
                    form: state,
                    breadcrumb: BlogAdminRoutes.authorsBreadcrumb
                )
            )
        )
    }

}
