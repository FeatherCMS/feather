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
            "/admin/account/invitations/add/",
            use: getAddAccountInvitation
        )
        router.post(
            "/admin/account/invitations/add/",
            use: postAddAccountInvitation
        )
    }
}
