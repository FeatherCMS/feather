struct AdminEditBlogSettings {
    let controller: any AdminEditBlogSettingsController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogSettingsDefaultInteractor(
                        repository: AdminEditBlogSettingsOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditBlogSettingsDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
