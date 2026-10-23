import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

struct AdminListMenuItem {
    let controller: any AdminListMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Menu.Router.Routes
    ) {
        self.controller = AdminListMenuItemDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminListMenuItemDefaultInteractor(
                        repository: AdminListMenuItemOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminListMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine,
                        routes: routes
                    )
                )
            }
        )
    }
}
