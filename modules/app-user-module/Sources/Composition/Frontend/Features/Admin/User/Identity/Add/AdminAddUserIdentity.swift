import FeatherAdmin

struct AdminAddUserIdentity {
    let controller: any AdminAddUserIdentityController

    init(
        apiBuilder: UserAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddUserIdentityDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddUserIdentityDefaultInteractor(
                        repository: AdminAddUserIdentityOpenAPIRepository(
                            api: apiBuilder.makeUserAdmin(context)
                        ),
                        roleRepository:
                            AdminAddUserIdentityRoleOpenAPIRepository(
                                api: apiBuilder.makeUserAdmin(context)
                            )
                    ),
                    presenter: AdminAddUserIdentityDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
