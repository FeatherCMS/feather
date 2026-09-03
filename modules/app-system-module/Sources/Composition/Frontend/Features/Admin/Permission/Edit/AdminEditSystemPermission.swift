import FeatherAdmin
import Hummingbird

struct AdminEditSystemPermission {
    let controller: any AdminEditSystemPermissionController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditSystemPermissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditSystemPermissionDefaultInteractor(
                        repository: AdminEditSystemPermissionOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminEditSystemPermissionDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
