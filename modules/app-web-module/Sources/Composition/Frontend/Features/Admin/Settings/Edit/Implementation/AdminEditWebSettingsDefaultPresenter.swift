import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebSettingsDefaultPresenter:
    AdminEditWebSettingsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: WebSettingsEdit.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Settings",
            content: WebSettingsEdit(state: state)
        )
    }

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "No permission",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.lock()
            )
        )
    }

    private func breadcrumb() -> [NewAdminBreadcrumb.Link] {
        [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
            ]
    }

}
