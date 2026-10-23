import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

struct AdminViewMenuItem {
    let controller: any AdminViewMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Menu.Router.Routes
    ) {
        self.controller = AdminViewMenuItemDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminViewMenuItemDefaultInteractor(
                        repository: AdminViewMenuItemOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminViewMenuItemDefaultPresenter(
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
