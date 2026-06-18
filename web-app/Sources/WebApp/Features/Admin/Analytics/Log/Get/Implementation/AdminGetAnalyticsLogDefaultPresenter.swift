import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetAnalyticsLogDefaultPresenter: AdminGetAnalyticsLogPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderPage(
        model: AdminGetAnalyticsLogModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Analytics log details - Feather CMS",
            description: "Analytics log details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AnalyticsLogDetails(
                state: .init(
                    log: model.log,
                    breadcrumb: breadcrumb(id: model.log.id)
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Analytics log details - Feather CMS",
            description: "Analytics log details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AnalyticsLogError(
                state: .init(
                    info: "Unable to load analytics log.",
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Analytics", link: "/admin/analytics/"),
                .init(label: "Logs", link: "/admin/analytics/logs/"),
                .init(label: "Details", link: "/admin/analytics/logs/\(id)/"),
            ]
        )
    }
}
