import Hummingbird

struct AdminGetUserInvitation {
    let controller: any AdminGetUserInvitationController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetUserInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetUserInvitationDefaultInteractor(
                        repository: UserInvitationOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetUserInvitationDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
