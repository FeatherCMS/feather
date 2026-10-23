import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import SystemWebAdmin

struct AdminAddMenuItem {
    let controller: any AdminAddMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddMenuItemDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminAddMenuItemDefaultInteractor(
                        repository: AdminAddMenuItemOpenAPIRepository(
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
                    presenter: AdminAddMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
