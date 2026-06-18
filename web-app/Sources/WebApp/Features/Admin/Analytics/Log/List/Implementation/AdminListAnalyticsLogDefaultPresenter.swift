import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListAnalyticsLogDefaultPresenter:
    AdminListAnalyticsLogPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListAnalyticsLogModel,
        permissions: Set<String>,
        search: String?,
        source: String?,
        method: String?,
        responseCode: String?,
        error: String?
    ) -> HTMLResponse {
        let scope = AdminAnalytics.Scope.logs
        let canAccess = permissions.contains(scope.permission(for: .list))
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Analytics logs - Feather CMS",
                description: "Analytics log list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: AnalyticsLogError(
                    state: .init(
                        info: "Unable to load analytics logs.",
                        message: error,
                        breadcrumb: analyticsLogBreadcrumbState()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Analytics logs - Feather CMS",
            description: "Analytics log list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AnalyticsLogTable(
                state: .init(
                    canAccess: canAccess,
                    permissions: permissions,
                    logs: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    source: source ?? model.source,
                    method: method ?? model.method,
                    responseCode: responseCode ?? model.responseCode,
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access analytics logs.",
                    breadcrumb: analyticsLogBreadcrumbState()
                )
            )
        )
    }

    private func analyticsLogBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Analytics", link: "/admin/analytics/"),
                .init(label: "Logs", link: "/admin/analytics/logs/"),
            ]
        )
    }
}
