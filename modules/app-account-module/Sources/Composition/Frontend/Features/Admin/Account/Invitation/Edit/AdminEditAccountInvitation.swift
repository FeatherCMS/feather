import FeatherAdmin
import Hummingbird

struct AdminEditAccountInvitation {
    let controller: any AdminEditAccountInvitationController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAccountInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAccountInvitationDefaultInteractor(
                        repository: AdminEditAccountInvitationOpenAPIRepository(
                            api: context.accountAdminAPI()
                        )
                    ),
                    presenter: AdminEditAccountInvitationDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
