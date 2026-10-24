import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Log.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine

        func renderPage(
            model: Log.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Analytics log details",
                content: Log.View.Component(
                    log: model.log,
                    breadcrumb: AnalyticsWebAdmin.Router.Routes.breadcrumb
                )
            )
        }

        func renderErrorPage(
            id: String,
            error: OpenAPIRepositoryError,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Analytics log details",
                content: Log.Status.Page(
                    breadcrumb: AnalyticsWebAdmin.Router.Routes.breadcrumb,
                    title: "Unable to load analytics log.",
                    message: error.errorDescription
                )
            )
        }
    }
}
