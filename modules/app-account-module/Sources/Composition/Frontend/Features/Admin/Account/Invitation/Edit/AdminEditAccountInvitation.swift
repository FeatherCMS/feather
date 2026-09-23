import FeatherAdmin

struct AdminEditAccountInvitation {
    let controller: any AdminEditAccountInvitationController

    init(apiBuilder: AccountAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAccountInvitationDefaultController(
            apiBuilder: apiBuilder,
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAccountInvitationDefaultInteractor(
                        repository: AdminEditAccountInvitationOpenAPIRepository(
                            api: apiBuilder.makeAccountAdmin(context)
                        )
                    ),
                    presenter: AdminEditAccountInvitationDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
