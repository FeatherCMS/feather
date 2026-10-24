import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Author.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Author.Router.Routes

        func render(
            state: Author.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add author",
                content: Author.Add.Component(
                    state: .init(
                        form: state,
                        breadcrumb: routes.authorsBreadcrumb,
                        routes: routes
                    )
                )
            )
        }
    }
}
