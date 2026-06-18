import Hummingbird

struct AdminRemoveUserInvitation {
    let controller: any AdminRemoveUserInvitationController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveUserInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveUserInvitationDefaultInteractor(
                        repository: AdminRemoveUserInvitationOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveUserInvitationDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
