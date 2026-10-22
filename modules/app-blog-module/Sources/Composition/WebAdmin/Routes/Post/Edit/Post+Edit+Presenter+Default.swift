import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Post.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Post.Router.Routes

        func render(
            id: String,
            state: Post.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit post",
                content: Post.Edit.Component(
                    state: .init(
                        id: id,
                        form: state,
                        breadcrumb: routes.postsBreadcrumb,
                        routes: routes
                    )
                )
            )
        }

        func renderError(
            id: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit post",
                content: Post.Error(
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
