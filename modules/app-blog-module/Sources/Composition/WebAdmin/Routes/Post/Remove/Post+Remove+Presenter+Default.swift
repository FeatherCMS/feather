import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Post.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Post.Router.Routes

        func renderError(
            id: String,
            info: String,
            message: String
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove post",
                content: BlogPostError(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.postsBreadcrumb
                    )
                )
            )
        }
    }
}
