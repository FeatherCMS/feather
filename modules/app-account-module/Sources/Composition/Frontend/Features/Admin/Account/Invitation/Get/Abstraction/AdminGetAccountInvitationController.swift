import FeatherAdmin
import Hummingbird

protocol AdminGetAccountInvitationController: Sendable {

    func getAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAccountInvitationController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.invitationDetailsPattern.description + "/"),
            use: getAccountInvitation
        )
    }
}
