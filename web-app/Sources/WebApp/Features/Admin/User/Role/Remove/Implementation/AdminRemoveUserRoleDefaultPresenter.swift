import Foundation
import Hummingbird

struct AdminRemoveUserRoleDefaultPresenter: AdminRemoveUserRolePresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderRemovePage(
        id: String,
        name: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Manage user roles - Feather CMS",
            description: "Management user role list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserRoleConfirmation(
                state: .init(
                    id: id,
                    name: name,
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
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove user role - Feather CMS",
            description: "Remove confirmation for a management user role",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserRoleError(
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
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Roles", link: "/admin/user/roles/"),
            .init(label: "Remove", link: "/admin/user/roles/\(id)/remove/"),
        ])
    }
}
