import FeatherAdmin
import Hummingbird

struct AdminResendAccountInvitation {

    let controller: AdminResendAccountInvitationDefaultController

    init(
        apiBuilder: AccountAPIBuilder,
    ) {
        self.controller = .init(
            buildRepository: { context in
                AdminResendAccountInvitationOpenAPIRepository(
                    api: apiBuilder.makeAccountAdmin(context)
                )
            }
        )
    }

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RouterPath(
                AccountAdminRoutes.invitationResendPattern.description + "/"
            ),
            use: controller.resend
        )
    }
}
