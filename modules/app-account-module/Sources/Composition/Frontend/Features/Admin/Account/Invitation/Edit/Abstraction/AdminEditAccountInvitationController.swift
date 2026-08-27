import FeatherAdmin
import Hummingbird

protocol AdminEditAccountInvitationController: Sendable {

    func getEditAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditAccountInvitationController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/account/invitations/{id}/edit/",
            use: getEditAccountInvitation
        )
        router.post(
            "/admin/account/invitations/{id}/edit/",
            use: postEditAccountInvitation
        )
    }
}
