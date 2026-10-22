import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import SystemWebAdmin

struct AdminEditWebMenuItem {
    let controller: any AdminEditWebMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMenuItemDefaultInteractor(
                        repository: AdminEditWebMenuItemOpenAPIRepository(
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
