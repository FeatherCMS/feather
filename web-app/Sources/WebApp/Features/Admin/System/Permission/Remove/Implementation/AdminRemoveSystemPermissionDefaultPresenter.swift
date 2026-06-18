import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminRemoveSystemPermissionDefaultPresenter:
    AdminRemoveSystemPermissionPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        id: String,
        name: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove system permission - Feather CMS",
            description:
                "Remove confirmation for a management system permission",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemPermissionConfirmation(
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
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove system permission - Feather CMS",
            description:
                "Remove confirmation for a management system permission",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemPermissionError(
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
                .init(label: "System", link: "/admin/system/"),
                .init(label: "Permissions", link: "/admin/system/permissions/"),
                .init(
                    label: "Remove",
                    link: "/admin/system/permissions/\(id)/remove/"
                ),
            ]
        )
    }
}
