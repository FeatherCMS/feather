import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime
import WebModule

struct AdminEditSettings {
    let controller: any AdminEditSettingsController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Settings.Router.Routes
    ) {
        self.controller = AdminEditSettingsDefaultController(
            routes: routes,
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminEditSettingsDefaultInteractor(
                        repository: AdminEditSettingsOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminEditSettingsDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
