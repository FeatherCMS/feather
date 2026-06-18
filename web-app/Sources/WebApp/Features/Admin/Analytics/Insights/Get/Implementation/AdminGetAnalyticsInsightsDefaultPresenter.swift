import HTML
import Hummingbird
import SGML

struct AdminGetAnalyticsInsightsDefaultPresenter:
    AdminGetAnalyticsInsightsPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func render(
        page: AdminAnalyticsInsightsPage,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: page.source.pageTitle,
            description: page.source.summary,
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AnalyticsInsightsView(
                page: page,
                permissions: permissions
            )
        )
    }

    func renderError(
        source: AdminAnalyticsInsightsPage.Source,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: source.pageTitle,
            description: source.summary,
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: .init(
                        links: [
                            .init(
                                label: "Analytics",
                                link: "/admin/analytics/"
                            ),
                            .init(
                                label: source.pageTitle,
                                link: source.pagePath
                            ),
                        ]
                    )
                )
            )
        )
    }

    func renderDenied(
        source: AdminAnalyticsInsightsPage.Source,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: source.pageTitle,
            description: source.summary,
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: "Your account cannot access analytics insights.",
                    message: "Ask an administrator for analytics permissions.",
                    breadcrumb: .init(
                        links: [
                            .init(
                                label: "Analytics",
                                link: "/admin/analytics/"
                            ),
                            .init(
                                label: source.pageTitle,
                                link: source.pagePath
                            ),
                        ]
                    )
                )
            )
        )
    }
}
