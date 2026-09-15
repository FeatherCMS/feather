import FeatherAdmin
import Hummingbird

protocol AdminViewAccountInvitationController: Sendable {

    func getAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAccountInvitationController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(
                AccountAdminRoutes.invitationDetailsPattern.description + "/"
            ),
            use: getAccountInvitation
        )
    }
}
