import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import SystemWebAdmin

struct AdminEditWebMenuItem {
    let controller: any AdminEditWebMenuItemController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMenuItemDefaultInteractor(
                        repository: AdminEditWebMenuItemOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        ),
                        permissionRepository:
                            AdminSystemPermissionOpenAPIRepository(
                                api: apiBuilder.makeSystemAdmin(context)
                            )
                    ),
                    presenter: AdminEditWebMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
