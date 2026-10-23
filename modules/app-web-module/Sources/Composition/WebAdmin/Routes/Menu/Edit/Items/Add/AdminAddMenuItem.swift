import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import SystemWebAdmin
import WebModule

struct AdminAddMenuItem {
    let controller: any AdminAddMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Menu.Router.Routes
    ) {
        self.controller = AdminAddMenuItemDefaultController(
            routes: routes,
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
                        renderingEngine: renderingEngine,
                        routes: routes
                    )
                )
            }
        )
    }
}
