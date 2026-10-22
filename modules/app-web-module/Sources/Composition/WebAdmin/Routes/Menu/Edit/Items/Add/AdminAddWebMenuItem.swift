import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import SystemWebAdmin

struct AdminAddWebMenuItem {
    let controller: any AdminAddWebMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebMenuItemDefaultInteractor(
                        repository: AdminAddWebMenuItemOpenAPIRepository(
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
