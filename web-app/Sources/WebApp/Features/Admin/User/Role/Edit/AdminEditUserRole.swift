import Hummingbird

struct AdminEditUserRole {
    let controller: any AdminEditUserRoleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditUserRoleDefaultInteractor(
                        repository: AdminEditUserRoleOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditUserRoleDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
