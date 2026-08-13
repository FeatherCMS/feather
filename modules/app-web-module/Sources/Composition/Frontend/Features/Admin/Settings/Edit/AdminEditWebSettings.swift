import FeatherAdmin
import OpenAPIRuntime

struct AdminEditWebSettings {
    let controller: any AdminEditWebSettingsController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebSettingsDefaultInteractor(
                        repository: AdminEditWebSettingsOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminEditWebSettingsDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
