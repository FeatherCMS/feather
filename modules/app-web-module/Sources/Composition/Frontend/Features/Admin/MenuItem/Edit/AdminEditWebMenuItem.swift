import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemFrontend

struct AdminEditWebMenuItem {
    let controller: any AdminEditWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMenuItemDefaultInteractor(
                        repository: AdminEditWebMenuItemOpenAPIRepository(
                            api: context.webManagementAPI()
                        ),
                        permissionRepository:
                            AdminSystemPermissionOpenAPIRepository(
                                api: context.systemManagementAPI()
                            )
                    ),
                    presenter: AdminEditWebMenuItemDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
