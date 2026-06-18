import HTML
import Hummingbird

struct AdminEditUserAccountDefaultPresenter:
    AdminEditUserAccountPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: UserAccountEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit account",
            description: "Edit user account",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserAccountEdit(state: state)
        )
    }

    func renderError(
        state: UserAccountError.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit account",
            description: "Edit user account",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: UserAccountError(state: state)
        )
    }

    func renderDeniedPage(
        breadcrumb: AdminBreadcrumb.State,
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
                    message: "Your account cannot edit user accounts.",
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
