import FeatherAdmin
import Hummingbird

protocol AdminRemoveAccountInvitationController: Sendable {

    func getRemoveAccountInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAccountInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveAccountInvitationController {

    func route(
        on router: Router<AppRequestContext>
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
