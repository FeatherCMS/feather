import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminEditSystemPermissionDefaultPresenter:
    AdminEditSystemPermissionPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: SystemPermissionForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Edit system permission - Feather CMS",
            description: "Edit a management system permission",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemPermissionEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: state,
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
            title: "Edit system permission - Feather CMS",
            description: "Edit a management system permission",
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
                    label: "Edit",
                    link: "/admin/system/permissions/\(id)/edit/"
                ),
            ]
        )
    }
}
