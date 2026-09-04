import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AdminGetUserRoleDefaultPresenter: AdminGetUserRolePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Roles", link: "/admin/user/roles/"),
            .init(label: "Details", link: "/admin/user/roles/\(id)/"),
        ])
    }

    func renderDetailsPage(
        role: UserRoleDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "User role details",
            description: "Management user role details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserRoleDetails(
                state: .init(
                    role: role,
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
            title: "User role details",
            description: "Management user role details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserRoleError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
