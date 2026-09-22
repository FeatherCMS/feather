import FeatherAdmin

struct AdminListAccountInvitation {
    let controller: any AdminListAccountInvitationController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListAccountInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAccountInvitationDefaultInteractor(
                        repository: AccountInvitationOpenAPIRepository(
                            api: context.accountAdminAPI()
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
