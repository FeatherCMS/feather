struct AdminEditWebSettings {
    let controller: any AdminEditWebSettingsController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebSettingsDefaultInteractor(
                        repository: AdminEditWebSettingsOpenAPIRepository(
                            api: context.managementAPI()
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
