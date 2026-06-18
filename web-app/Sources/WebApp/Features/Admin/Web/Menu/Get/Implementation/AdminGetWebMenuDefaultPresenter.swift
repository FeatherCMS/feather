import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetWebMenuDefaultPresenter: AdminGetWebMenuPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: WebMenuDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>,
        isAdded: Bool,
        isRemoved: Bool
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Menu details - Feather CMS",
            description: "Management menu details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: breadcrumb,
                    permissions: permissions,
                    isAdded: isAdded,
                    isRemoved: isRemoved
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
            title: "Menu details - Feather CMS",
            description: "Management menu details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuError(
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
            .init(label: "Web", link: "/admin/web/"),
            .init(label: "Menus", link: "/admin/web/menus/"),
            .init(label: "Details", link: "/admin/web/menus/\(id)/"),
        ])
    }
}
