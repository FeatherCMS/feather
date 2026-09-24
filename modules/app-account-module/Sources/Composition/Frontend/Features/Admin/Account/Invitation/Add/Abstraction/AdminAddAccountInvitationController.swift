import FeatherAdmin
import Hummingbird

protocol AdminAddAccountInvitationController: Sendable {

    func getAddAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddAccountInvitationController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.invitationAdd.description + "/"),
            use: getAddAccountInvitation
        )
        router.post(
            RouterPath(AccountAdminRoutes.invitationAdd.description + "/"),
            use: postAddAccountInvitation
        )
    }
}
