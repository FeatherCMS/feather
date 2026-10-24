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
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Tag.Router.Routes

        func renderDetailsPage(
            model: Tag.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Blog tag details",
                content: Tag.View.Component(
                    state: .init(
                        model: model,
                        breadcrumb: routes.tagsBreadcrumb,
                        permissions: permissions,
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Blog tag details",
                content: Tag.Error(
                    state: .init(
                        info: info,
                        message: message,
                        breadcrumb: routes.tagsBreadcrumb
                    )
                )
            )
        }
    }
}
