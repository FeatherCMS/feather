import FeatherAdmin

struct AdminEditUserIdentity {
    let controller: any AdminEditUserIdentityController

    init(apiBuilder: UserAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminEditUserIdentityDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditUserIdentityDefaultInteractor(
                        identityRepository:
                            AdminEditUserIdentityOpenAPIRepository(
                                api: apiBuilder.makeUserAdmin(context)
                            ),
                        roleRepository:
                            AdminEditUserIdentityRoleOpenAPIRepository(
                                api: apiBuilder.makeUserAdmin(context)
                            )
                    ),
                    presenter: AdminEditUserIdentityDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
