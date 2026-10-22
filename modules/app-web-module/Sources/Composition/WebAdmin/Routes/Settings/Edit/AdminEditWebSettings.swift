import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

struct AdminEditWebSettings {
    let controller: any AdminEditWebSettingsController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditWebSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebSettingsDefaultInteractor(
                        repository: AdminEditWebSettingsOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminEditWebSettingsDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
