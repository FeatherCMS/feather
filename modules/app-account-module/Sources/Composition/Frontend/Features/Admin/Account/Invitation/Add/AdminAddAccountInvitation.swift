import FeatherAdmin
import Hummingbird

struct AdminAddAccountInvitation {

    let controller: any AdminAddAccountInvitationController

    init(
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddAccountInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAccountInvitationDefaultInteractor(
                        repository: AdminAddAccountInvitationOpenAPIRepository(
                            api: context.accountAdminAPI()
                        )
                    ),
                    presenter: AdminAddAccountInvitationDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
