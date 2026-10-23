import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import SystemWebAdmin
import WebModule

struct AdminEditMenuItem {
    let controller: any AdminEditMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Menu.Router.Routes
    ) {
        self.controller = AdminEditMenuItemDefaultController(
            routes: routes,
            buildRuntime: { request, context in
                WebAdminRuntime(
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
                        renderingEngine: renderingEngine,
                        routes: routes
                    )
                )
            }
        )
    }
}
