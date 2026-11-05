import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Settings.Edit.Presenter {

    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Settings.Router.Routes

        func renderPage(
            state: Settings.Edit.Page.State,
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
                content: Settings.Edit.Page(routes: routes, state: state)
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
}
