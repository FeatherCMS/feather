import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

protocol AdminRemoveAccountInvitationController: Sendable {

    func postRemoveAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveAccountInvitationController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            RouterPath(AccountAdminRoutes.invitationRemoveBulk.description + "/"),
            use: postRemoveAccountInvitation
        )
    }
}
