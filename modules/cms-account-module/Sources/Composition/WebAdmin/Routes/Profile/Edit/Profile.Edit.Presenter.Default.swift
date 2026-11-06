import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Profile.Edit.Presenter {

    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Profile.Router.Routes

        func renderPage(
            state: Profile.Edit.Page.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            var state = state
            state.form.nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit profile",
                content: Profile.Edit.Page(routes: routes, state: state)
            )
        }

        func renderDeniedPage(
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "No permission",
                content: AdminStatusView(
                    state: .init(
                        title: "No permission",
                        message: "Your identity cannot edit the profile."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

    }
}
