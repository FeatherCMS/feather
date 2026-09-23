import FeatherAdmin

struct AdminViewUserRole {
    let controller: any AdminViewUserRoleController

    init(apiBuilder: UserAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminViewUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewUserRoleDefaultInteractor(
                        repository: AdminViewUserRoleOpenAPIRepository(
                            api: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminViewUserRoleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
