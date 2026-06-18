import HTML
import Hummingbird
import SGML

struct AdminGetAuthProfileDefaultPresenter:
    AdminGetAuthProfilePresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthProfileDetails.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Profile - Feather CMS",
            description: "View your profile details",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AuthProfileDetails(state: state)
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
                    message: "Your account cannot view the profile.",
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
            ]
        )
    }
}
