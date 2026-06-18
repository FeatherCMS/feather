import Hummingbird

protocol AdminAddUserInvitationController: Sendable {

    func getAddUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddUserInvitationController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/invitations/add/",
            use: getAddUserInvitation
        )
        router.post(
            "/admin/user/invitations/add/",
            use: postAddUserInvitation
        )
    }
}
