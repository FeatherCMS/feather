import Hummingbird

struct AdminAddMediaProcessor {
    let controller: any AdminAddMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddMediaProcessorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
