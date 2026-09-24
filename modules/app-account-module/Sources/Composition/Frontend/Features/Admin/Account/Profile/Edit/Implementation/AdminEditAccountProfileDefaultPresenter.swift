import FeatherAdmin
import Hummingbird

struct AdminEditAccountProfileDefaultPresenter:
    AdminEditAccountProfilePresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AccountProfileEdit.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        var state = state
        state.form.nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit profile",
            content: AccountProfileEdit(state: state)
        )
    }

    func renderDeniedPage(
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "No permission",
            content: NewAdminStatusView(
                state: .init(
                    title: "No permission",
                    message: "Your identity cannot edit the profile."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

}
