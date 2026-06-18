import Hummingbird

struct AdminListUserRole {
    let controller: any AdminListUserRoleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListUserRoleDefaultInteractor(
                        repository: AdminListUserRoleOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListUserRoleDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
