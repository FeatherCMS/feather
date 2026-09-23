import FeatherAdmin
import OpenAPIRuntime

struct AdminEditWebSettings {
    let controller: any AdminEditWebSettingsController

    init(apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebSettingsDefaultInteractor(
                        repository: AdminEditWebSettingsOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
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
