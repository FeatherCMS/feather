import Hummingbird

protocol AdminRemoveUserInvitationController: Sendable {

    func getRemoveUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveUserInvitationController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/invitations/{id}/remove/",
            use: getRemoveUserInvitation
        )
        router.post(
            "/admin/user/invitations/{id}/remove/",
            use: postRemoveUserInvitation
        )
    }
}
