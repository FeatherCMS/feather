import Hummingbird

struct AdminEditAuthProfile {
    let controller: any AdminEditAuthProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAuthProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthProfileDefaultInteractor(
                        repository: AdminEditAuthProfileOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditAuthProfileDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
