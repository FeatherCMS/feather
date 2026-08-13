import FeatherAdmin
import Hummingbird

struct AdminGetAccountInvitation {
    let controller: any AdminGetAccountInvitationController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAccountInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAccountInvitationDefaultInteractor(
                        repository: AccountInvitationOpenAPIRepository(
                            api: context.accountAdminAPI()
                        )
                    ),
                    presenter: AdminGetAccountInvitationDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
