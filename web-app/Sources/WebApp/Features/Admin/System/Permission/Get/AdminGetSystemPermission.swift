import Hummingbird

struct AdminGetSystemPermission {
    let controller: any AdminGetSystemPermissionController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetSystemPermissionDefaultController(
            buildRuntime: { request, context in
                let repository = AdminGetSystemPermissionOpenAPIRepository(
                    api: context.managementAPI()
                )
                let interactor = AdminGetSystemPermissionDefaultInteractor(
                    repository: repository
                )
                let presenter = AdminGetSystemPermissionDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
                return (
                    interactor: interactor,
                    presenter: presenter
                )
            }
        )
    }
}
