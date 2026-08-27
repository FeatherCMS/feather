import FeatherAdmin
import HTML
import Hummingbird

struct AdminEditSettingsDefaultPresenter:
    AdminEditSettingsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        state: SettingsEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Settings - Feather CMS",
            description: "Edit your settings",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SettingsEdit(state: state)
        )
    }

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "No permission - Feather CMS",
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
                .init(label: "Account", link: "/admin/account/"),
                .init(label: "Settings", link: "/admin/account/settings/"),
            ]
        )
    }
}
