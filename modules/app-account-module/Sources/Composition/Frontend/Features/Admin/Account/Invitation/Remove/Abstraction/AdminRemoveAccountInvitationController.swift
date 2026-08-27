import FeatherAdmin
import Hummingbird

protocol AdminRemoveAccountInvitationController: Sendable {

    func getRemoveAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveAccountInvitationController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/account/invitations/{id}/remove/",
            use: getRemoveAccountInvitation
        )
        router.post(
            "/admin/account/invitations/{id}/remove/",
            use: postRemoveAccountInvitation
        )
    }
}
