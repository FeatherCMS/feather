import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: BlogWebAdmin.Router.Routes

        func render(
            id: String,
            state: BlogTagForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit tag",
                content: Tag.Edit.Component(
                    state: .init(
                        id: id,
                        form: state,
                        breadcrumb: routes.tagsBreadcrumb,
                        routes: routes
                    )
                )
            )
        }

        func renderError(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit tag",
                content: BlogTagError(
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
