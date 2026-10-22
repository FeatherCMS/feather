import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Profile.Detail.Presenter {

    struct Default:
        Profile.Detail.Presenter.Interface
    {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Profile.Router.Routes

        func renderPage(
            state: ProfileDetails.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Profile",
                content: ProfileDetails(routes: routes, state: state)
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
                        message: "Your identity cannot view the profile."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

    }
}
