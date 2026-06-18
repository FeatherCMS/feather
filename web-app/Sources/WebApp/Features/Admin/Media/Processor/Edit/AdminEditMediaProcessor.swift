import Hummingbird

struct AdminEditMediaProcessor {
    let controller: any AdminEditMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditMediaProcessorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
