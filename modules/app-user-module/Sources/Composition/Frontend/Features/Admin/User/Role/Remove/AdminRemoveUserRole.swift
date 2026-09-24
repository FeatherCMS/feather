import FeatherAdmin

struct AdminRemoveUserRole {
    let controller: any AdminRemoveUserRoleController

    init(
        apiBuilder: UserAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveUserRoleDefaultInteractor(
                        repository: AdminRemoveUserRoleOpenAPIRepository(
                            api: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveUserRoleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
