import Hummingbird

struct AdminAddUserInvitation {

    let controller: any AdminAddUserInvitationController

    init(
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddUserInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddUserInvitationDefaultInteractor(
                        repository: AdminAddUserInvitationOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddUserInvitationDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
