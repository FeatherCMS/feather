import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Remove.Presenter {

    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Invitation.Router.Routes

        func renderRemovePage(
            item: AdminRemoveItemContext
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: Invitation.Remove.Confirmation(
                    routes: routes,
                    state: .init(
                        id: item.id,
                        email: item.label,
                        breadcrumb: routes.invitationRemoveBreadcrumb(item.id),
                        nonceToken: nonceToken
                    )
                ),
                size: .small
            )
        }

        func renderErrorPage(
            id: String,
            info: String,
            message: String
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove user invitation",
                content: AdminStatusView(
                    state: .init(title: info, message: message),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

    }
}
