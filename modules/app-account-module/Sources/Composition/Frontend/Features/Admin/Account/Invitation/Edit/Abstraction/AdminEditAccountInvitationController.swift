import FeatherAdmin
import Hummingbird

protocol AdminEditAccountInvitationController: Sendable {

    func getEditAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditAccountInvitationController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(
                AccountAdminRoutes.invitationEditPattern.description + "/"
            ),
            use: getEditAccountInvitation
        )
        router.post(
            RouterPath(
                AccountAdminRoutes.invitationEditPattern.description + "/"
            ),
            use: postEditAccountInvitation
        )
    }
}
