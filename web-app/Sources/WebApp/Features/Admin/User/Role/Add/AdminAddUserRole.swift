import AdminOpenAPI
import Hummingbird

struct AdminAddUserRole {
    let controller: any AdminAddUserRoleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddUserRoleDefaultInteractor(
                        repository: AdminAddUserRoleOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddUserRoleDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
