import Hummingbird

struct AdminAddWebPage {
    let controller: any AdminAddWebPageController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebPageDefaultInteractor(
                        repository: AdminAddWebPageOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddWebPageDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
