import FeatherAdmin
import Hummingbird

protocol AdminListAccountInvitationController: Sendable {

    func getAccountInvitations(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getAccountInvitationsBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postAccountInvitationsBulkRemove(
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
            "/admin/account/invitations/bulk-remove/",
            use: getAccountInvitationsBulkRemoveConfirmation
        )
        router.post(
            "/admin/account/invitations/bulk-remove/",
            use: postAccountInvitationsBulkRemove
        )
    }
}
