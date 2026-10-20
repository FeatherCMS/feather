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

struct AdminAddBlogTagDefaultPresenter: AdminAddBlogTagPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: BlogTagForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Add tag",
            content: BlogTagAdd(
                state: .init(
                    form: state,
                    breadcrumb: BlogAdminRoutes.tagsBreadcrumb
                )
            )
        )
    }

}
