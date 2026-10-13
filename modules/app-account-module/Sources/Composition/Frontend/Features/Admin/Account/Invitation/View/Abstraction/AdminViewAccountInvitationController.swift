import FeatherAdmin
import Hummingbird

protocol AdminViewAccountInvitationController: Sendable {

    func getAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAccountInvitationController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RouterPath(
                AccountAdminRoutes.invitationDetailsPattern.description + "/"
            ),
            use: getAccountInvitation
        )
    }
}
