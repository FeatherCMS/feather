import FeatherAdmin
import Hummingbird

struct AdminEditSystemPermission {
    let controller: any AdminEditSystemPermissionController

    init(
        apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditSystemPermissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditSystemPermissionDefaultInteractor(
                        repository: AdminEditSystemPermissionOpenAPIRepository(
                            api: apiBuilder.makeSystemAdmin(context)
                        )
                    ),
                    presenter: AdminEditSystemPermissionDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
