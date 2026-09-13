import FeatherAdmin
import HTML
import Hummingbird

struct AdminViewUserRole {
    let controller: any AdminViewUserRoleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewUserRoleDefaultInteractor(
                        repository: AdminViewUserRoleOpenAPIRepository(
                            api: context.userAdminAPI()
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
