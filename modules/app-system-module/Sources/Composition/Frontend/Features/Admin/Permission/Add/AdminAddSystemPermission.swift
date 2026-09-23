import FeatherAdmin
import Hummingbird

struct AdminAddSystemPermission {
    let controller: any AdminAddSystemPermissionController

    init(apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminAddSystemPermissionDefaultController(
            buildRuntime: { request, context in
                let repository = AdminAddSystemPermissionOpenAPIRepository(
                    api: apiBuilder.makeSystemAdmin(context)
                )
                let interactor = AdminAddSystemPermissionDefaultInteractor(
                    repository: repository
                )
                let presenter = AdminAddSystemPermissionDefaultPresenter(
                    request: request,
                    context: context,
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
