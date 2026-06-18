import Hummingbird

struct AdminRemoveMediaProcessor {
    let controller: any AdminRemoveMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveMediaProcessorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
