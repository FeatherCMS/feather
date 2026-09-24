import FeatherAdmin
import Hummingbird

protocol AdminListAccountInvitationController: Sendable {

    func getAccountInvitations(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func getAccountInvitationsRemoveConfirmation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postAccountInvitationsRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminListAccountInvitationController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AccountAdminRoutes.invitations,
            use: getAccountInvitations
        )
        router.get(
            RouterPath(
                AccountAdminRoutes.invitationRemoveBulk.description + "/"
            ),
            use: getAccountInvitationsRemoveConfirmation
        )
        router.post(
            RouterPath(
                AccountAdminRoutes.invitationRemoveBulk.description + "/"
            ),
            use: postAccountInvitationsRemove
        )
    }
}
