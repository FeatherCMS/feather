import FeatherAdmin
import Hummingbird

protocol AdminAddAccountInvitationController: Sendable {

    func getAddAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddAccountInvitationController {

    func route(
        on router: Router<DefaultRequestContext>
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
