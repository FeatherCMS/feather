import Hummingbird

protocol AdminGetUserInvitationController: Sendable {

    func getUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetUserInvitationController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/invitations/{id}/",
            use: getUserInvitation
        )
    }
}
