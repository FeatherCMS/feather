import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebSettingsDefaultPresenter:
    AdminEditWebSettingsPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: WebSettingsEdit.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
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
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "No permission",
            content: AdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.lock()
            )
        )
    }

}
