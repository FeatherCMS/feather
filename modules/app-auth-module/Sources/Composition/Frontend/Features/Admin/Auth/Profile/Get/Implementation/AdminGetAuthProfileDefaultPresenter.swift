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

struct AdminGetAuthProfileDefaultPresenter:
    AdminGetAuthProfilePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthProfileDetails.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Profile",
            content: AuthProfileDetails(state: state)
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

    private func breadcrumb() -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Account", link: "/admin/account/"),
            .init(label: "Profile", link: "/admin/auth/profile/"),
        ]
    }
}
