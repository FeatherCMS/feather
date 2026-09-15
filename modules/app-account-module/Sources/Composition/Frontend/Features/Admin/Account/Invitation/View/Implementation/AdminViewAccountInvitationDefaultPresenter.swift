import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird

struct AdminViewAccountInvitationDefaultPresenter:
    AdminViewAccountInvitationPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        invitation: AccountInvitationDetailsModel,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User invitation details",
            content: AccountInvitationDetails(
                state: .init(invitation: invitation, breadcrumb: breadcrumb)
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User invitation details",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    func breadcrumb(id: String) -> [NewAdminBreadcrumb.Link] {
        AccountAdminRoutes.invitationBreadcrumb + [
            .init(
                label: "Details",
                link: AccountAdminRoutes.invitationDetails(RouterPath(id))
                    .description
            )
        ]
    }
}
