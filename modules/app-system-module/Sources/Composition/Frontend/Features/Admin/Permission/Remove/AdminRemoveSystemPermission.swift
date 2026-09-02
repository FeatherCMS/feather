import FeatherAdmin
import Hummingbird

struct AdminRemoveSystemPermission {
    let controller: any AdminRemoveSystemPermissionController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveSystemPermissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveSystemPermissionDefaultInteractor(
                        repository:
                            AdminRemoveSystemPermissionOpenAPIRepository(
                                api: context.systemAdminAPI()
                            )
                    ),
                    presenter: AdminRemoveSystemPermissionDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
