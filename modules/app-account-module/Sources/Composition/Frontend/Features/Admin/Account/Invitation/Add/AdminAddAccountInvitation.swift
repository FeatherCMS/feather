import FeatherAdmin

struct AdminAddAccountInvitation {

    let controller: any AdminAddAccountInvitationController

    init(apiBuilder: AccountAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddAccountInvitationDefaultController(
            apiBuilder: apiBuilder,
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAccountInvitationDefaultInteractor(
                        repository: AdminAddAccountInvitationOpenAPIRepository(
                            api: apiBuilder.makeAccountAdmin(context)
                        )
                    ),
                    presenter: AdminAddAccountInvitationDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
