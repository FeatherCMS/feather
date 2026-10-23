import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

struct AdminEditSettings {
    let controller: any AdminEditSettingsController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditSettingsDefaultController(
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
