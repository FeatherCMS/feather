import FeatherAdmin
import Hummingbird

protocol AdminEditAccountInvitationController: Sendable {

    func getEditAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditAccountInvitationController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RouterPath(
                AccountAdminRoutes.invitationEditPattern.description + "/"
            ),
            use: getEditAccountInvitation
        )
        router.post(
            RouterPath(
                AccountAdminRoutes.invitationEditPattern.description + "/"
            ),
            use: postEditAccountInvitation
        )
    }
}
