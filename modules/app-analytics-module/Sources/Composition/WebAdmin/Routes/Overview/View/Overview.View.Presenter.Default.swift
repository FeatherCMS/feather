import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine

        func renderOverview(
            model: Overview.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: model.title,
                content: Overview.View.Component()
            )
        }
    }
}
