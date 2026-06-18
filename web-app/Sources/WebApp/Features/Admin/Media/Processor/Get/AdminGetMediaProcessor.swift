import Hummingbird

struct AdminGetMediaProcessor {
    let controller: any AdminGetMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetMediaProcessorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
