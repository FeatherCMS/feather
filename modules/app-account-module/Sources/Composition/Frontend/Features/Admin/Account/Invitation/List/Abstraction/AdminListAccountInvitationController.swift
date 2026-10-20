import FeatherWebAdmin
import Hummingbird

protocol AdminListAccountInvitationController: Sendable {

    func getAccountInvitations(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListAccountInvitationController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AccountAdminRoutes.invitations,
            use: getAccountInvitations
        )
    }
}
