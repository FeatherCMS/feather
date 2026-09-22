import FeatherAdmin
import Hummingbird

struct AdminRemoveAccountInvitationDefaultPresenter:
    AdminRemoveAccountInvitationPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderRemovePage(
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user invitation",
            content: AccountInvitationConfirmation(
                state: .init(
                    id: item.id,
                    email: item.label,
                    breadcrumb: AccountAdminRoutes.invitationRemoveBreadcrumb(
                        RouterPath(item.id)
                    ),
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user invitation",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

}
