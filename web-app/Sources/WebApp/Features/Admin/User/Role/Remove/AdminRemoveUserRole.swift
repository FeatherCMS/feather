import Hummingbird

struct AdminRemoveUserRole {
    let controller: any AdminRemoveUserRoleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveUserRoleDefaultInteractor(
                        repository: AdminRemoveUserRoleOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveUserRoleDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
