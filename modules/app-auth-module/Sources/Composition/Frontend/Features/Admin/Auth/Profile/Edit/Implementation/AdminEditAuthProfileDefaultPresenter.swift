import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminEditAuthProfileDefaultPresenter:
    AdminEditAuthProfilePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthProfileEdit.State,
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
            content: AuthProfileEdit(state: state)
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

    private func breadcrumb() -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Account", link: "/admin/account/"),
            .init(label: "Profile", link: "/admin/auth/profile/"),
        ]
    }
}
