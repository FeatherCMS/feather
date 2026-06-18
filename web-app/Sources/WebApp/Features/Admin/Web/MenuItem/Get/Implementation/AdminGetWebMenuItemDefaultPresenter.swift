import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetWebMenuItemDefaultPresenter: AdminGetWebMenuItemPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: WebMenuItemDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Item details - Feather CMS",
            description: "Management item details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuItemDetails(
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
            title: "Item details - Feather CMS",
            description: "Management item details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuItemError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func breadcrumb(
        menuId: String,
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Web", link: "/admin/web/"),
            .init(label: "Menus", link: "/admin/web/menus/"),
            .init(label: "Menu", link: "/admin/web/menus/\(menuId)/"),
            .init(label: "Items", link: "/admin/web/menus/\(menuId)/items/"),
            .init(
                label: "Details",
                link: "/admin/web/menus/\(menuId)/items/\(id)/"
            ),
        ])
    }
}
