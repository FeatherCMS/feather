import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import SystemWebAdmin

struct AdminAddWebMenuItem {
    let controller: any AdminAddWebMenuItemController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebMenuItemDefaultInteractor(
                        repository: AdminAddWebMenuItemOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        ),
                        permissionRepository:
                            AdminSystemPermissionOpenAPIRepository(
                                api: apiBuilder.makeSystemAdmin(context)
                            )
                    ),
                    presenter: AdminAddWebMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
