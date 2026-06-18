import Hummingbird

struct AdminListMediaProcessors {
    let controller: any AdminListMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListMediaProcessorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
