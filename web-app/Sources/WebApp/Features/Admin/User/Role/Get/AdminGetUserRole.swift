import HTML
import Hummingbird

struct AdminGetUserRole {
    let controller: any AdminGetUserRoleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetUserRoleDefaultInteractor(
                        repository: AdminGetUserRoleOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetUserRoleDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
