import FeatherAdmin
import Hummingbird

struct AdminViewAccountProfileDefaultPresenter:
    AdminViewAccountProfilePresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AccountProfileDetails.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Profile",
            content: AccountProfileDetails(state: state)
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
                    message: "Your identity cannot view the profile."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

}
