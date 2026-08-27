import FeatherAdmin
import Foundation
import Hummingbird

struct AdminGetAnalyticsNotFoundDefaultPresenter:
    AdminGetAnalyticsNotFoundPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func render(
        model: AdminGetAnalyticsNotFoundModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: model.title,
            description: model.description,
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AnalyticsNotFoundView(model: model)
        )
    }

    func renderDenied(
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "404s",
            description: "404 trends and missing routes.",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: "Your account cannot access 404 analytics.",
                    message: "Ask an administrator for analytics permissions.",
                    breadcrumb: analyticsNotFoundBreadcrumb
                )
            )
        )
    }

    func renderError(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "404s",
            description: "404 trends and missing routes.",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: analyticsNotFoundBreadcrumb
                )
            )
        )
    }

    private var analyticsNotFoundBreadcrumb: AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Redirect", link: "/admin/analytics/"),
                .init(label: "404s", link: "/admin/analytics/not-found/"),
            ]
        )
    }
}
