import Hummingbird

struct AdminListSystemPermission {
    let controller: any AdminListSystemPermissionController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListSystemPermissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemPermissionDefaultInteractor(
                        repository: AdminListSystemPermissionOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListSystemPermissionDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
