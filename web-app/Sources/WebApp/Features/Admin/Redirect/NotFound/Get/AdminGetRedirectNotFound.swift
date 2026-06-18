struct AdminGetRedirectNotFound {
    let controller: any AdminGetRedirectNotFoundController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetRedirectNotFoundDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetRedirectNotFoundDefaultInteractor(
                        repository: AdminGetRedirectNotFoundOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetRedirectNotFoundDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
