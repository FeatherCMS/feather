import FeatherAdmin
import Hummingbird

struct AdminRemoveAccountInvitation {
    let controller: any AdminRemoveAccountInvitationController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveAccountInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAccountInvitationDefaultInteractor(
                        repository:
                            AdminRemoveAccountInvitationOpenAPIRepository(
                                api: context.accountAdminAPI()
                            )
                    ),
                    presenter: AdminRemoveAccountInvitationDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
