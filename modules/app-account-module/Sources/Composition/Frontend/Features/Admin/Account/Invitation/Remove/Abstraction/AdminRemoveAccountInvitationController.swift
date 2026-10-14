import FeatherAdmin
import Hummingbird

protocol AdminRemoveAccountInvitationController: Sendable {

    func postRemoveAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveAccountInvitationController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            RouterPath(
                AccountAdminRoutes.invitationRemovePattern.description + "/"
            ),
            use: postRemoveAccountInvitation
        )
    }
}
