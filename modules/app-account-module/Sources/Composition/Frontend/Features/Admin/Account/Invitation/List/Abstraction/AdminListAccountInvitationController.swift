import FeatherAdmin
import Hummingbird

protocol AdminListAccountInvitationController: Sendable {

    func getAccountInvitations(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getAccountInvitationsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postAccountInvitationsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListAccountInvitationController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/account/invitations",
            use: getAccountInvitations
        )
        router.get(
            "/admin/account/invitations/remove/",
            use: getAccountInvitationsRemoveConfirmation
        )
        router.post(
            "/admin/account/invitations/remove/",
            use: postAccountInvitationsRemove
        )
    }
}
