import FeatherAdmin
import Hummingbird

struct AdminListSystemPermission {
    let controller: any AdminListSystemPermissionController

    init(
        apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListSystemPermissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemPermissionDefaultInteractor(
                        repository: AdminListSystemPermissionOpenAPIRepository(
                            api: apiBuilder.makeSystemAdmin(context)
                        )
                    ),
                    presenter: AdminListSystemPermissionDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
