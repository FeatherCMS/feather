import Hummingbird

protocol AdminListUserInvitationController: Sendable {

    func getUserInvitations(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getUserInvitationsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postUserInvitationsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListUserInvitationController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/invitations",
            use: getUserInvitations
        )
        router.get(
            "/admin/user/invitations/bulk-remove/",
            use: getUserInvitationsBulkRemoveConfirmation
        )
        router.post(
            "/admin/user/invitations/bulk-remove/",
            use: postUserInvitationsBulkRemove
        )
    }
}
