import Hummingbird

struct AdminEditSystemPermission {
    let controller: any AdminEditSystemPermissionController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditSystemPermissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditSystemPermissionDefaultInteractor(
                        repository: AdminEditSystemPermissionOpenAPIRepository(
                            api: context.managementAPI()
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
