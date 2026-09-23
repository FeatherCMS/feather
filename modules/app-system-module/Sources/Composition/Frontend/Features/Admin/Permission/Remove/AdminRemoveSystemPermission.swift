import FeatherAdmin
import Hummingbird

struct AdminRemoveSystemPermission {
    let controller: any AdminRemoveSystemPermissionController

    init(apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveSystemPermissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveSystemPermissionDefaultInteractor(
                        repository:
                            AdminRemoveSystemPermissionOpenAPIRepository(
                                api: apiBuilder.makeSystemAdmin(context)
                            )
                    ),
                    presenter: AdminRemoveSystemPermissionDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
