import HTML
import Hummingbird
import SGML

struct AdminEditAuthProfileDefaultPresenter:
    AdminEditAuthProfilePresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthProfileEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit profile - Feather CMS",
            description: "Edit your profile",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthProfileEdit(state: state)
        )
    }

    func renderDeniedPage(
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "No permission - Feather CMS",
            description: "No permission",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: "No permission",
                    message: "Your account cannot edit the profile.",
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Auth", link: "/admin/auth/"),
                .init(label: "Profile", link: "/admin/auth/profile/"),
                .init(
                    label: "Edit",
                    link: "/admin/auth/profile/edit/"
                ),
            ]
        )
    }
}
