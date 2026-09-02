import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebSettingsDefaultPresenter:
    AdminEditWebSettingsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: WebSettingsEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Settings",
            description: "Edit web settings",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebSettingsEdit(state: state)
        )
    }

    func renderDeniedPage(
        info: String,
        message: String,
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
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Settings", link: "/admin/web/settings/"),
            ]
        )
    }
}
