import FeatherAdmin
import Hummingbird

protocol AdminAddAccountInvitationController: Sendable {

    func getAddAccountInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddAccountInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddAccountInvitationController {

    func route(
        on router: Router<AppRequestContext>
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
