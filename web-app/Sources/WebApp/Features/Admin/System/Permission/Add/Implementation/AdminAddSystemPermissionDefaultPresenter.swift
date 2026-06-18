import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminAddSystemPermissionDefaultPresenter:
    AdminAddSystemPermissionPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: SystemPermissionForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add system permission - Feather CMS",
            description: "Add a system permission in management",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemPermissionAdd(
                state: .init(
                    form: state,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "System", link: "/admin/system/"),
                .init(
                    label: "Permissions",
                    link: "/admin/system/permissions/"
                ),
                .init(
                    label: "Add",
                    link: "/admin/system/permissions/add/"
                ),
            ]
        )
    }
}
