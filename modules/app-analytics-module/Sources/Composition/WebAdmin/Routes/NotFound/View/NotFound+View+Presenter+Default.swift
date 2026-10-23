import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension NotFound.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine

        func render(
            model: NotFound.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: model.title,
                content: NotFound.View.Component(model: model)
            )
        }

        func renderDenied(
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "404s",
                content: AnalyticsAdminStatusView(
                    breadcrumb: AnalyticsWebAdmin.Router.Routes.breadcrumb,
                    title: "Forbidden",
                    message: "Your account cannot access 404 analytics."
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
                title: "404s",
                content: AnalyticsAdminStatusView(
                    breadcrumb: AnalyticsWebAdmin.Router.Routes.breadcrumb,
                    title: info,
                    message: message
                )
            )
        }
    }
}
