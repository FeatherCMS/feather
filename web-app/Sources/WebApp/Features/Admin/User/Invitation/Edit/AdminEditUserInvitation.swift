import Hummingbird

struct AdminEditUserInvitation {
    let controller: any AdminEditUserInvitationController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditUserInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditUserInvitationDefaultInteractor(
                        repository: AdminEditUserInvitationOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditUserInvitationDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
