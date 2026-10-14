import FeatherAdmin
import Hummingbird

struct AdminEditSettingsDefaultPresenter:
    AdminEditSettingsPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: SettingsEdit.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        var state = state
        state.form.nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Settings",
            content: SettingsEdit(state: state)
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
            title: "Settings",
            content: AdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

}
