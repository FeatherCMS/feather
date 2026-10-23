import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Insight.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine

        func render(
            page: Insight.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: page.source.pageTitle,
                content: Insight.View.Component(page: page)
            )
        }

        func renderError(
            source: Insight.View.Model.Source,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: source.pageTitle,
                content: StatusView(
                    breadcrumb: AnalyticsWebAdmin.Router.Routes.breadcrumb,
                    title: info,
                    message: message
                )
            )
        }

        func renderDenied(
            source: Insight.View.Model.Source,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: source.pageTitle,
                content: StatusView(
                    breadcrumb: AnalyticsWebAdmin.Router.Routes.breadcrumb,
                    title: "Forbidden",
                    message: "Your account cannot access analytics insights."
                )
            )
        }
    }
}
