import Hummingbird

struct AdminAddSystemPermission {
    let controller: any AdminAddSystemPermissionController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddSystemPermissionDefaultController(
            buildRuntime: { request, context in
                let repository = AdminAddSystemPermissionOpenAPIRepository(
                    api: context.managementAPI()
                )
                let interactor = AdminAddSystemPermissionDefaultInteractor(
                    repository: repository
                )
                let presenter = AdminAddSystemPermissionDefaultPresenter(
                    request: request,
                    renderingEngine: renderingEngine
                )
                return (
                    interactor: interactor,
                    presenter: presenter
                )
            }
        )
    }
}
