import Hummingbird

struct AdminListUserInvitation {
    let controller: any AdminListUserInvitationController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListUserInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListUserInvitationDefaultInteractor(
                        repository: UserInvitationOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListUserInvitationDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
