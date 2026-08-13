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
                            api: context.systemManagementAPI()
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
