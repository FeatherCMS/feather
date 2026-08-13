import FeatherAdmin
import Hummingbird

protocol AdminGetAccountInvitationController: Sendable {

    func getAccountInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAccountInvitationController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/account/invitations/{id}/",
            use: getAccountInvitation
        )
    }
}
