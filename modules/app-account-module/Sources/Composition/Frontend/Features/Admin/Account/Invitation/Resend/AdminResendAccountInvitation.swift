import FeatherAdmin
import Hummingbird

struct AdminResendAccountInvitation {

    let controller: AdminResendAccountInvitationDefaultController

    init() {
        self.controller = .init(
            buildRepository: { context in
                AdminResendAccountInvitationOpenAPIRepository(
                    api: context.accountAdminAPI()
                )
            }
        )
    }

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/account/invitations/{id}/resend/",
            use: controller.resend
        )
    }
}
