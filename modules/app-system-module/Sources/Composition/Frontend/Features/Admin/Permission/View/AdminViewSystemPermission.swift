import FeatherAdmin
import Hummingbird

struct AdminViewSystemPermission {
    let controller: any AdminViewSystemPermissionController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewSystemPermissionDefaultController(
            buildRuntime: { request, context in
                let repository = AdminViewSystemPermissionOpenAPIRepository(
                    api: context.systemAdminAPI()
                )
                let interactor = AdminViewSystemPermissionDefaultInteractor(
                    repository: repository
                )
                let presenter = AdminViewSystemPermissionDefaultPresenter(
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
