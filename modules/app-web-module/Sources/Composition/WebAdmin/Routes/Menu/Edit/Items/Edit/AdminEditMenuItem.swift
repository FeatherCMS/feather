import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import SystemWebAdmin

struct AdminEditMenuItem {
    let controller: any AdminEditMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMenuItemDefaultInteractor(
                        repository: AdminEditMenuItemOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        ),
                        permissionRepository:
                            AdminSystemPermissionOpenAPIRepository(
                                api: SystemWebAdmin.API.Client(
                                    apiBaseURL: environment.apiBaseURL,
                                    requestContext: context
                                )
                            )
                    ),
                    presenter: AdminEditMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
