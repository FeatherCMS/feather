import FeatherWebAdmin
import Hummingbird
import RedirectModule

extension Overview.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let ruleRoutes: RedirectModule.Rule.Router.Routes

        func renderOverview(
            model: Overview.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: model.title,
                content: Overview.Content(routes: ruleRoutes)
            )
        }
    }
}
