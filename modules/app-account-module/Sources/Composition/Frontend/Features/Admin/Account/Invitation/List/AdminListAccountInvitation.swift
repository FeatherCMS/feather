import FeatherAdmin

struct AdminListAccountInvitation {
    let controller: any AdminListAccountInvitationController

    init(apiBuilder: AccountAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminListAccountInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAccountInvitationDefaultInteractor(
                        repository: AccountInvitationOpenAPIRepository(
                            api: apiBuilder.makeAccountAdmin(context)
                        )
                    ),
                    presenter: AdminListAccountInvitationDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
