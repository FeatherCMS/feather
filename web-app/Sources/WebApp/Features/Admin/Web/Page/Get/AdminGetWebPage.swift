import Hummingbird

struct AdminGetWebPage {
    let controller: any AdminGetWebPageController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetWebPageDefaultInteractor(
                        repository: AdminGetWebPageOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetWebPageDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
