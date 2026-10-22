import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Detail.Presenter {

    struct Default:
        Invitation.Detail.Presenter.Interface
    {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Invitation.Router.Routes

        func renderDetailsPage(
            invitation: AccountInvitationDetailsModel,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User invitation details",
                content: AccountInvitationDetails(
                    routes: routes,
                    state: .init(
                        invitation: invitation,
                        breadcrumb: routes.invitationDetailsBreadcrumb(
                            invitation.id
                        )
                    )
                )
            )
        }

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User invitation details",
                content: AdminStatusView(
                    state: .init(title: info, message: message),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

    }
}
