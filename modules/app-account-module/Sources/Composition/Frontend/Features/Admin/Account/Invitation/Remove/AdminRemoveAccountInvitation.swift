import FeatherAdmin

struct AdminRemoveAccountInvitation {
    let controller: any AdminRemoveAccountInvitationController

    init(
        apiBuilder: AccountAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveAccountInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAccountInvitationDefaultInteractor(
                        repository:
                            AdminRemoveAccountInvitationOpenAPIRepository(
                                api: apiBuilder.makeAccountAdmin(context)
                            )
                    ),
                    presenter: AdminRemoveAccountInvitationDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
