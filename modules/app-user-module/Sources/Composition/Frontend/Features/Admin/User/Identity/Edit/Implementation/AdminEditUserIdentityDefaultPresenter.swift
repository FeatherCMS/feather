import FeatherAdmin
import HTML
import Hummingbird

struct AdminEditUserIdentityDefaultPresenter:
    AdminEditUserIdentityPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: UserIdentityEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit identity",
            description: "Edit user identity",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserIdentityEdit(state: state)
        )
    }

    func renderError(
        state: UserIdentityError.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit identity",
            description: "Edit user identity",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserIdentityError(state: state)
        )
    }

    func renderDeniedPage(
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "No permission",
            description: "No permission",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: PermissionDeniedView(
                state: .init(
                    info: "No permission",
                    message: "Your identity cannot edit user identities.",
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
