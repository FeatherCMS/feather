import FeatherAdmin
import Hummingbird

protocol AdminListAccountInvitationController: Sendable {

    func getAccountInvitations(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getAccountInvitationsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postAccountInvitationsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListAccountInvitationController {

    func route(
        on router: Router<AppRequestContext>
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
