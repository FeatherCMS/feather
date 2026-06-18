import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetRedirectRuleDefaultPresenter: AdminGetRedirectRulePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: RedirectRuleDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Redirect rule details - Feather CMS",
            description: "Management redirect rule details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: RedirectRuleDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Redirect rule details - Feather CMS",
            description: "Management redirect rule details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: RedirectRuleError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Redirect", link: "/admin/redirect/"),
            .init(label: "Rules", link: "/admin/redirect/rules/"),
            .init(label: "Details", link: "/admin/redirect/rules/\(id)/"),
        ])
    }
}
