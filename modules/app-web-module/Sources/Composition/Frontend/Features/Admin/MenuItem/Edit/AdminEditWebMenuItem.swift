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
                            api: context.webAdminAPI()
                        ),
                        permissionRepository:
                            AdminSystemPermissionOpenAPIRepository(
                                api: context.systemAdminAPI()
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
