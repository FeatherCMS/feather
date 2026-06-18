import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminRemoveWebMenuItemDefaultPresenter:
    AdminRemoveWebMenuItemPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        menuId: String,
        id: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove item - Feather CMS",
            description: "Remove confirmation for a management item",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuItemConfirmation(
                state: .init(
                    menuId: menuId,
                    id: id,
                    label: label,
                    breadcrumb: breadcrumb(menuId: menuId, id: id)
                )
            )
        )
    }

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove item - Feather CMS",
            description: "Remove confirmation for a management item",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuItemError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(menuId: menuId, id: id)
                )
            )
        )
    }

    func breadcrumb(
        menuId: String,
        id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Menus", link: "/admin/web/menus/"),
                .init(label: "Menu", link: "/admin/web/menus/\(menuId)/"),
                .init(
                    label: "Items",
                    link: "/admin/web/menus/\(menuId)/items/"
                ),
                .init(
                    label: "Remove",
                    link: "/admin/web/menus/\(menuId)/items/\(id)/remove/"
                ),
            ]
        )
    }
}
