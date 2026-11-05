import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Author.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Author.Router.Routes

        func renderError(
            info: String,
            message: String
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove author",
                content: Author.Error(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.authorsBreadcrumb
                    )
                )
            )
        }
    }
}
