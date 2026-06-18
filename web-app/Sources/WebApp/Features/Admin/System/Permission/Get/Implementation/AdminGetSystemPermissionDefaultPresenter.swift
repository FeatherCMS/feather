import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetSystemPermissionDefaultPresenter:
    AdminGetSystemPermissionPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "System", link: "/admin/system/"),
            .init(label: "Permissions", link: "/admin/system/permissions/"),
            .init(label: "Details", link: "/admin/system/permissions/\(id)/"),
        ])
    }

    func renderDetailsPage(
        permission: SystemPermissionDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "System permission details - Feather CMS",
            description: "Management system permission details",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemPermissionDetails(
                state: .init(
                    permission: permission,
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
        renderEngine.renderAdminPage(
            request: request,
            title: "System permission details - Feather CMS",
            description: "Management system permission details",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemPermissionError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
