import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

struct AdminRemoveMenuItem {
    let controller: any AdminRemoveMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Menu.Router.Routes
    ) {
        self.controller = AdminRemoveMenuItemDefaultController(
            routes: routes,
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminRemoveMenuItemDefaultInteractor(
                        repository: AdminRemoveMenuItemOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminRemoveMenuItemDefaultPresenter(
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
