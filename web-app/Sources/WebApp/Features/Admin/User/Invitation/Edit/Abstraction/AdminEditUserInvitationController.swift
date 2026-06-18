import Hummingbird

protocol AdminEditUserInvitationController: Sendable {

    func getEditUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditUserInvitation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditUserInvitationController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/invitations/{id}/edit/",
            use: getEditUserInvitation
        )
        router.post(
            "/admin/user/invitations/{id}/edit/",
            use: postEditUserInvitation
        )
    }
}
