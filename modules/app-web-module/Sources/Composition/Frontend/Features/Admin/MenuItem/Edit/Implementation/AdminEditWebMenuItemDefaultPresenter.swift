import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditWebMenuItemDefaultPresenter: AdminEditWebMenuItemPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        menuId: String,
        id: String,
        state: WebMenuItemForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Edit item",
            description: "Edit a management item",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuItemEdit(
                state: .init(
                    menuId: menuId,
                    id: id,
                    isEdited: isEdited,
                    form: state,
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
            title: "Edit item",
            description: "Edit a management item",
            imagePath: "images/logos/logo.png",
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
                    label: "Edit",
                    link: "/admin/web/menus/\(menuId)/items/\(id)/edit/"
                ),
            ]
        )
    }
}
