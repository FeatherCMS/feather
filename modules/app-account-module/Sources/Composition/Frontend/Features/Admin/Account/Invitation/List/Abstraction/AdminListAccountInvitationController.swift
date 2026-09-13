import FeatherAdmin
import Hummingbird

protocol AdminListAccountInvitationController: Sendable {

    func getAccountInvitations(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getAccountInvitationsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postAccountInvitationsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListAccountInvitationController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            AccountAdminRoutes.invitations,
            use: getAccountInvitations
        )
        router.get(
            RouterPath(AccountAdminRoutes.invitationRemoveBulk.description + "/"),
            use: getAccountInvitationsRemoveConfirmation
        )
        router.post(
            RouterPath(AccountAdminRoutes.invitationRemoveBulk.description + "/"),
            use: postAccountInvitationsRemove
        )
    }
}
