import Hummingbird

struct AdminEditAccountSettings {
    let controller: any AdminEditAccountSettingsController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAccountSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAccountSettingsDefaultInteractor(
                        repository: AdminEditAccountSettingsOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditAccountSettingsDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
