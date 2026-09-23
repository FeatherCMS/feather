import FeatherAdmin
import Hummingbird

protocol AdminRemoveAccountInvitationController: Sendable {

    func getRemoveAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveAccountInvitationController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RouterPath(
                AccountAdminRoutes.invitationRemovePattern.description + "/"
            ),
            use: getRemoveAccountInvitation
        )
        router.post(
            RouterPath(
                AccountAdminRoutes.invitationRemovePattern.description + "/"
            ),
            use: postRemoveAccountInvitation
        )
    }
}
