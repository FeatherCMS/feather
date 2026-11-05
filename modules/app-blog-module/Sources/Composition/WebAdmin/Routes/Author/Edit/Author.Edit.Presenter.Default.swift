import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Author.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Author.Router.Routes

        func render(
            id: String,
            state: Author.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit author",
                content: Author.Edit.Component(
                    state: .init(
                        id: id,
                        form: state,
                        breadcrumb: routes.authorsBreadcrumb,
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
                title: "Edit author",
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
