import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird

struct AdminRemoveAccountInvitationDefaultPresenter:
    AdminRemoveAccountInvitationPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderRemovePage(
        id: String,
        email: String,
        permissions: Set<String>
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
                    id: id,
                    email: email,
                    breadcrumb: breadcrumb(id: id),
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
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

    func breadcrumb(id: String) -> [NewAdminBreadcrumb.Link] {
        AccountAdminRoutes.invitationBreadcrumb + [
            .init(
                label: "Remove",
                link: AccountAdminRoutes.invitationRemove(RouterPath(id)).description
            )
        ]
    }
}
