import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemFrontend

struct AdminAddWebMenuItem {
    let controller: any AdminAddWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebMenuItemDefaultInteractor(
                        repository: AdminAddWebMenuItemOpenAPIRepository(
                            api: context.webManagementAPI()
                        ),
                        permissionRepository:
                            AdminSystemPermissionOpenAPIRepository(
                                api: context.systemManagementAPI()
                            )
                    ),
                    presenter: AdminAddWebMenuItemDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
