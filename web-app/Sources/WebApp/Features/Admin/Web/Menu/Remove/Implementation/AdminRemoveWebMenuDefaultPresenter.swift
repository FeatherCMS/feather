import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminRemoveWebMenuDefaultPresenter:
    AdminRemoveWebMenuPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        id: String,
        source: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove menu - Feather CMS",
            description: "Remove confirmation for a management menu",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuConfirmation(
                state: .init(
                    id: id,
                    source: source,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove menu - Feather CMS",
            description: "Remove confirmation for a management menu",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuError(
                state: .init(
                    info: info,
                    message: message,
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
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Menus", link: "/admin/web/menus/"),
                .init(
                    label: "Remove",
                    link: "/admin/web/menus/\(id)/remove/"
                ),
            ]
        )
    }
}
