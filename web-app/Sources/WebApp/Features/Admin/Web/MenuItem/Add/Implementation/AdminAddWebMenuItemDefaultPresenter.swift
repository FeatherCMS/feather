import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminAddWebMenuItemDefaultPresenter: AdminAddWebMenuItemPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        menuId: String,
        state: WebMenuItemForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add item - Feather CMS",
            description: "Add an item in management",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuItemAdd(
                state: .init(
                    menuId: menuId,
                    form: state,
                    breadcrumb: breadcrumb(menuId: menuId)
                )
            )
        )
    }

    func breadcrumb(
        menuId: String
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
                    label: "Add",
                    link: "/admin/web/menus/\(menuId)/items/add/"
                ),
            ]
        )
    }
}
